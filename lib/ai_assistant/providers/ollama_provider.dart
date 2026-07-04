import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/ai_config.dart';
import '../models/ai_message.dart';
import '../models/ai_response.dart';
import '../models/function_call.dart';
import '../models/token_usage.dart';
import 'ai_provider.dart';

/// Provider for local Ollama instances.
///
/// Defaults to `http://localhost:11434` but can be customised via
/// [AIConfig.baseUrl].
class OllamaProvider implements AIProvider {
  final AIConfig config;
  final http.Client _client;

  OllamaProvider({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  @override
  String get displayName => 'Ollama';

  String get _baseUrl => config.baseUrl ?? 'http://localhost:11434';

  @override
  Future<AIResponse> generateResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  }) async {
    final body = _buildRequestBody(messages, systemPrompt, stream: false);
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Ollama API error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final message = json['message'] as Map<String, dynamic>;
    final content = message['content'] as String? ?? '';

    final promptTokens = json['prompt_eval_count'] as int? ?? 0;
    final evalTokens = json['eval_count'] as int? ?? 0;

    return AIResponse(
      text: content,
      tokenUsage: TokenUsage(
        promptTokens: promptTokens,
        completionTokens: evalTokens,
        totalTokens: promptTokens + evalTokens,
      ),
    );
  }

  @override
  Stream<String> streamResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  }) async* {
    final body = _buildRequestBody(messages, systemPrompt, stream: true);
    final request = http.Request('POST', Uri.parse('$_baseUrl/api/chat'))
      ..headers.addAll({'Content-Type': 'application/json'})
      ..body = jsonEncode(body);

    final streamedResponse = await _client.send(request);

    await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
      for (final line in chunk.split('\n')) {
        if (line.trim().isEmpty) continue;
        try {
          final json = jsonDecode(line) as Map<String, dynamic>;
          final message = json['message'] as Map<String, dynamic>?;
          final content = message?['content'] as String?;
          if (content != null && content.isNotEmpty) yield content;
        } catch (_) {}
      }
    }
  }

  Map<String, dynamic> _buildRequestBody(
    List<AIMessage> messages,
    String systemPrompt, {
    required bool stream,
  }) {
    final msgs = <Map<String, dynamic>>[
      {'role': 'system', 'content': systemPrompt},
      ...messages.map((m) => {
            'role': m.role == MessageRole.user ? 'user' : 'assistant',
            'content': m.content,
          }),
    ];

    return {
      'model': config.model,
      'messages': msgs,
      'stream': stream,
      'options': {
        'temperature': config.temperature,
        'num_predict': config.maxTokens,
      },
    };
  }
}
