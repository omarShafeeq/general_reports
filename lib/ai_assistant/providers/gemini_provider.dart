import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/ai_config.dart';
import '../models/ai_message.dart';
import '../models/ai_response.dart';
import '../models/function_call.dart';
import '../models/token_usage.dart';
import 'ai_provider.dart';

/// Provider for Google Gemini API.
class GeminiProvider implements AIProvider {
  final AIConfig config;
  final http.Client _client;

  GeminiProvider({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  @override
  String get displayName => 'Gemini';

  String get _baseUrl =>
      config.baseUrl ??
      'https://generativelanguage.googleapis.com/v1beta';

  @override
  Future<AIResponse> generateResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  }) async {
    final body = _buildRequestBody(messages, systemPrompt, functions);
    final url =
        '$_baseUrl/models/${config.model}:generateContent?key=${config.apiKey}';

    final response = await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      return const AIResponse(text: 'No response generated.');
    }

    final content = candidates.first['content'] as Map<String, dynamic>;
    final parts = content['parts'] as List;
    final text = parts.map((p) => p['text'] as String? ?? '').join('');

    final usageMeta = json['usageMetadata'] as Map<String, dynamic>?;

    return AIResponse(
      text: text,
      tokenUsage: usageMeta != null
          ? TokenUsage(
              promptTokens: usageMeta['promptTokenCount'] as int? ?? 0,
              completionTokens:
                  usageMeta['candidatesTokenCount'] as int? ?? 0,
              totalTokens: usageMeta['totalTokenCount'] as int? ?? 0,
            )
          : null,
    );
  }

  @override
  Stream<String> streamResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  }) async* {
    final body = _buildRequestBody(messages, systemPrompt, functions);
    final url =
        '$_baseUrl/models/${config.model}:streamGenerateContent?key=${config.apiKey}&alt=sse';

    final request = http.Request('POST', Uri.parse(url))
      ..headers.addAll({'Content-Type': 'application/json'})
      ..body = jsonEncode(body);

    final streamedResponse = await _client.send(request);

    await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
      for (final line in chunk.split('\n')) {
        if (!line.startsWith('data: ')) continue;
        try {
          final json =
              jsonDecode(line.substring(6)) as Map<String, dynamic>;
          final candidates = json['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final content =
                candidates.first['content'] as Map<String, dynamic>;
            final parts = content['parts'] as List;
            for (final part in parts) {
              final text = part['text'] as String?;
              if (text != null) yield text;
            }
          }
        } catch (_) {}
      }
    }
  }

  Map<String, dynamic> _buildRequestBody(
    List<AIMessage> messages,
    String systemPrompt,
    List<FunctionDefinition>? functions,
  ) {
    final contents = <Map<String, dynamic>>[];

    for (final msg in messages) {
      contents.add({
        'role': msg.role == MessageRole.user ? 'user' : 'model',
        'parts': [
          {'text': msg.content}
        ],
      });
    }

    final body = <String, dynamic>{
      'contents': contents,
      'systemInstruction': {
        'parts': [
          {'text': systemPrompt}
        ],
      },
      'generationConfig': {
        'temperature': config.temperature,
        'maxOutputTokens': config.maxTokens,
      },
    };

    if (functions != null && functions.isNotEmpty) {
      body['tools'] = [
        {
          'functionDeclarations': functions
              .map((f) => {
                    'name': f.name,
                    'description': f.description,
                    'parameters': {
                      'type': 'OBJECT',
                      'properties': f.parameters
                          .map((k, v) => MapEntry(k, {
                                'type': v.type.toUpperCase(),
                                'description': v.description,
                              })),
                      'required': f.parameters.entries
                          .where((e) => e.value.required)
                          .map((e) => e.key)
                          .toList(),
                    },
                  })
              .toList(),
        }
      ];
    }

    return body;
  }
}
