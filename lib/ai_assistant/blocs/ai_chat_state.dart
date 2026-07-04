import 'package:equatable/equatable.dart';

import '../models/ai_message.dart';
import '../models/ai_response.dart';

enum AIChatStatus { idle, sending, streaming, error }

class AIChatState extends Equatable {
  final String? conversationId;
  final List<AIMessage> messages;
  final AIChatStatus status;
  final String? errorMessage;
  final String streamBuffer;
  final AIResponse? lastResponse;

  const AIChatState({
    this.conversationId,
    this.messages = const [],
    this.status = AIChatStatus.idle,
    this.errorMessage,
    this.streamBuffer = '',
    this.lastResponse,
  });

  bool get isLoading =>
      status == AIChatStatus.sending || status == AIChatStatus.streaming;

  bool get hasError => status == AIChatStatus.error;

  bool get isEmpty => messages.isEmpty;

  AIChatState copyWith({
    String? conversationId,
    List<AIMessage>? messages,
    AIChatStatus? status,
    String? errorMessage,
    String? streamBuffer,
    AIResponse? lastResponse,
  }) {
    return AIChatState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage,
      streamBuffer: streamBuffer ?? this.streamBuffer,
      lastResponse: lastResponse ?? this.lastResponse,
    );
  }

  @override
  List<Object?> get props => [
        conversationId,
        messages,
        status,
        errorMessage,
        streamBuffer,
        lastResponse,
      ];
}
