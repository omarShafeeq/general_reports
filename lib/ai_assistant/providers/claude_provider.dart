import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/ai_config.dart';
import '../models/ai_message.dart';
import '../models/ai_response.dart';
import '../models/function_call.dart';
import '../models/token_usage.dart';
import 'ai_provider.dart';

/// Provider for Anthropic Claude API.
class ClaudeProvider implements AIProvider {
  final AIConfig config;
  final http.Client _client;

  ClaudeProvider({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  @override
  String get displayName => 'Claude';

  String get _baseUrl =>
      config.baseUrl ?? 'https://api.anthropic.com/v1';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'x-api-key': config.apiKey ?? '',
        'anthropic-version': '2023-06-01',
      };

  @override
  Future<AIResponse> generateResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  }) async {
    final body = _buildRequestBody(messages, systemPrompt, functions);
    final response = await _client.post(
      Uri.parse('$_baseUrl/messages'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final content = json['content'] as List;
    final text = content
        .where((c) => c['type'] == 'text')
        .map((c) => c['text'] as String)
        .join('');
    final usage = json['usage'] as Map<String, dynamic>?;

    return AIResponse(
      text: text,
      tokenUsage: usage != null
          ? TokenUsage(
              promptTokens: usage['input_tokens'] as int? ?? 0,
              completionTokens: usage['output_tokens'] as int? ?? 0,
              totalTokens: (usage['input_tokens'] as int? ?? 0) +
                  (usage['output_tokens'] as int? ?? 0),
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
    body['stream'] = true;

    final request = http.Request('POST', Uri.parse('$_baseUrl/messages'))
      ..headers.addAll(_headers)
      ..body = jsonEncode(body);

    final streamedResponse = await _client.send(request);

    await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
      for (final line in chunk.split('\n')) {
        if (!line.startsWith('data: ')) continue;
        try {
          final json =
              jsonDecode(line.substring(6)) as Map<String, dynamic>;
          if (json['type'] == 'content_block_delta') {
            final delta = json['delta'] as Map<String, dynamic>;
            final text = delta['text'] as String?;
            if (text != null) yield text;
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
    final msgs = messages
        .map((m) => {
              'role': m.role == MessageRole.user ? 'user' : 'assistant',
              'content': m.content,
            })
        .toList();

    final body = <String, dynamic>{
      'model': config.model,
      'system': systemPrompt,
      'messages': msgs,
      'max_tokens': config.maxTokens,
      'temperature': config.temperature,
    };

    if (functions != null && functions.isNotEmpty) {
      body['tools'] = functions
          .map((f) => {
                'name': f.name,
                'description': f.description,
                'input_schema': {
                  'type': 'object',
                  'properties': f.parameters
                      .map((k, v) => MapEntry(k, v.toSchema())),
                  'required': f.parameters.entries
                      .where((e) => e.value.required)
                      .map((e) => e.key)
                      .toList(),
                },
              })
          .toList();
    }

    return body;
  }
}
