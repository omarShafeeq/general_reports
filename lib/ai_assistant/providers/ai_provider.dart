import '../models/ai_message.dart';
import '../models/ai_response.dart';
import '../models/function_call.dart';

/// Provider-agnostic interface for AI model communication.
///
/// Implementations handle the HTTP transport and response parsing for a
/// specific backend (OpenAI, Claude, Gemini, Ollama, etc.).  The rest of the
/// application interacts exclusively through this contract.
abstract class AIProvider {
  /// One-shot (non-streaming) response.
  Future<AIResponse> generateResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  });

  /// Streaming response – yields partial text chunks as they arrive.
  Stream<String> streamResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  });

  /// Provider display name for UI/logging.
  String get displayName;
}
