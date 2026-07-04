import 'package:equatable/equatable.dart';

class TokenUsage extends Equatable {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  const TokenUsage({
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalTokens = 0,
  });

  TokenUsage operator +(TokenUsage other) => TokenUsage(
        promptTokens: promptTokens + other.promptTokens,
        completionTokens: completionTokens + other.completionTokens,
        totalTokens: totalTokens + other.totalTokens,
      );

  @override
  List<Object?> get props => [promptTokens, completionTokens, totalTokens];
}
