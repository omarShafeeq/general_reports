import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/ai_config.dart';
import '../models/ai_message.dart';
import '../models/ai_response.dart';
import '../models/function_call.dart';
import '../models/token_usage.dart';
import 'ai_provider.dart';

/// Provider for OpenAI and Azure OpenAI APIs.
///
/// Set [AIConfig.providerType] to [AIProviderType.azureOpenai] and provide
/// `baseUrl` + `apiKey` for Azure deployments.
class OpenAIProvider implements AIProvider {
  final AIConfig config;
  final http.Client _client;

  OpenAIProvider({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  @override
  String get displayName =>
      config.providerType == AIProviderType.azureOpenai
          ? 'Azure OpenAI'
          : 'OpenAI';

  String get _baseUrl =>
      config.baseUrl ?? 'https://api.openai.com/v1';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${config.apiKey}',
      };

  @override
  Future<AIResponse> generateResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  }) async {
    final body = _buildRequestBody(messages, systemPrompt, functions);
    final response = await _client.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final choice = (json['choices'] as List).first as Map<String, dynamic>;
    final message = choice['message'] as Map<String, dynamic>;
    final usage = json['usage'] as Map<String, dynamic>?;

    return AIResponse(
      text: message['content'] as String? ?? '',
      tokenUsage: usage != null
          ? TokenUsage(
              promptTokens: usage['prompt_tokens'] as int? ?? 0,
              completionTokens: usage['completion_tokens'] as int? ?? 0,
              totalTokens: usage['total_tokens'] as int? ?? 0,
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

    final request = http.Request('POST', Uri.parse('$_baseUrl/chat/completions'))
      ..headers.addAll(_headers)
      ..body = jsonEncode(body);

    final streamedResponse = await _client.send(request);

    await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
      for (final line in chunk.split('\n')) {
        if (!line.startsWith('data: ') || line.trim() == 'data: [DONE]') {
          continue;
        }
        try {
          final json =
              jsonDecode(line.substring(6)) as Map<String, dynamic>;
          final delta = ((json['choices'] as List).first
              as Map<String, dynamic>)['delta'] as Map<String, dynamic>?;
          final content = delta?['content'] as String?;
          if (content != null) yield content;
        } catch (_) {}
      }
    }
  }

  Map<String, dynamic> _buildRequestBody(
    List<AIMessage> messages,
    String systemPrompt,
    List<FunctionDefinition>? functions,
  ) {
    final msgs = <Map<String, dynamic>>[
      {'role': 'system', 'content': systemPrompt},
      ...messages.map((m) => {
            'role': m.role == MessageRole.user ? 'user' : 'assistant',
            'content': m.content,
          }),
    ];

    final body = <String, dynamic>{
      'model': config.model,
      'messages': msgs,
      'temperature': config.temperature,
      'max_tokens': config.maxTokens,
    };

    if (functions != null && functions.isNotEmpty) {
      body['tools'] = functions.map((f) => f.toToolSchema()).toList();
    }

    return body;
  }
}
