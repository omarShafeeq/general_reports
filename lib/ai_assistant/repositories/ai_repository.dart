import '../models/ai_message.dart';
import '../models/ai_response.dart';
import '../providers/ai_provider.dart';
import '../services/function_registry.dart';
import '../services/prompt_builder.dart';

/// Orchestrates AI interactions by combining the provider, prompt builder,
/// and function registry into a single high-level API.
class AIRepository {
  final AIProvider _provider;
  final PromptBuilder _promptBuilder;
  final FunctionRegistry _functionRegistry;

  const AIRepository({
    required AIProvider provider,
    required PromptBuilder promptBuilder,
    required FunctionRegistry functionRegistry,
  })  : _provider = provider,
        _promptBuilder = promptBuilder,
        _functionRegistry = functionRegistry;

  /// Sends a one-shot request and returns a complete response.
  Future<AIResponse> send(List<AIMessage> messages) async {
    final systemPrompt = _promptBuilder.build(
      functions: _functionRegistry.definitions,
    );

    return _provider.generateResponse(
      messages: messages,
      systemPrompt: systemPrompt,
      functions: _functionRegistry.definitions,
    );
  }

  /// Sends a streaming request.  Yields partial text chunks.
  Stream<String> stream(List<AIMessage> messages) {
    final systemPrompt = _promptBuilder.build(
      functions: _functionRegistry.definitions,
    );

    return _provider.streamResponse(
      messages: messages,
      systemPrompt: systemPrompt,
      functions: _functionRegistry.definitions,
    );
  }

  String get providerName => _provider.displayName;
}
