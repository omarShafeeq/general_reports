import 'package:equatable/equatable.dart';

import '../providers/ai_provider.dart';
import '../providers/claude_provider.dart';
import '../providers/gemini_provider.dart';
import '../providers/mock_provider.dart';
import '../providers/ollama_provider.dart';
import '../providers/openai_provider.dart';

enum AIProviderType { openai, azureOpenai, claude, gemini, ollama, mock }

/// Runtime configuration for the AI assistant.
///
/// API keys should be loaded from environment variables or secure storage –
/// never hardcoded in source.
class AIConfig extends Equatable {
  final AIProviderType providerType;
  final String model;
  final String? apiKey;
  final String? baseUrl;
  final double temperature;
  final int maxTokens;
  final bool enableStreaming;
  final bool enableFunctionCalling;

  const AIConfig({
    this.providerType = AIProviderType.mock,
    this.model = 'mock-1',
    this.apiKey,
    this.baseUrl,
    this.temperature = 0.7,
    this.maxTokens = 4096,
    this.enableStreaming = true,
    this.enableFunctionCalling = true,
  });

  /// Default development configuration using the mock provider.
  static const dev = AIConfig();

  AIConfig copyWith({
    AIProviderType? providerType,
    String? model,
    String? apiKey,
    String? baseUrl,
    double? temperature,
    int? maxTokens,
    bool? enableStreaming,
    bool? enableFunctionCalling,
  }) {
    return AIConfig(
      providerType: providerType ?? this.providerType,
      model: model ?? this.model,
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      enableStreaming: enableStreaming ?? this.enableStreaming,
      enableFunctionCalling: enableFunctionCalling ?? this.enableFunctionCalling,
    );
  }

  /// Creates the [AIProvider] instance for the current configuration.
  AIProvider createProvider() {
    switch (providerType) {
      case AIProviderType.openai:
      case AIProviderType.azureOpenai:
        return OpenAIProvider(config: this);
      case AIProviderType.claude:
        return ClaudeProvider(config: this);
      case AIProviderType.gemini:
        return GeminiProvider(config: this);
      case AIProviderType.ollama:
        return OllamaProvider(config: this);
      case AIProviderType.mock:
        return MockProvider();
    }
  }

  @override
  List<Object?> get props => [
        providerType,
        model,
        apiKey,
        baseUrl,
        temperature,
        maxTokens,
        enableStreaming,
        enableFunctionCalling,
      ];
}
