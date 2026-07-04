import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ai_message.dart';
import '../models/function_call.dart';
import '../repositories/ai_repository.dart';
import '../repositories/conversation_repository.dart';
import '../services/function_registry.dart';
import '../services/report_detector.dart';
import 'ai_chat_state.dart';

/// Manages the active chat conversation, sending messages, streaming
/// responses, and synchronising with the [ConversationRepository].
class AIChatCubit extends Cubit<AIChatState> {
  final AIRepository _aiRepository;
  final ConversationRepository _conversationRepository;
  final ReportDetector _reportDetector;
  final FunctionRegistry _functionRegistry;
  StreamSubscription<String>? _streamSubscription;

  AIChatCubit({
    required AIRepository aiRepository,
    required ConversationRepository conversationRepository,
    required ReportDetector reportDetector,
    required FunctionRegistry functionRegistry,
  })  : _aiRepository = aiRepository,
        _conversationRepository = conversationRepository,
        _reportDetector = reportDetector,
        _functionRegistry = functionRegistry,
        super(const AIChatState());

  /// Load an existing conversation into the chat view.
  void loadConversation(String conversationId) {
    final conv = _conversationRepository.getById(conversationId);
    if (conv == null) return;

    emit(AIChatState(
      conversationId: conv.id,
      messages: conv.messages,
      status: AIChatStatus.idle,
    ));
  }

  /// Start a fresh conversation.
  void newConversation() {
    final conv = _conversationRepository.create();
    emit(AIChatState(
      conversationId: conv.id,
      status: AIChatStatus.idle,
    ));
  }

  /// Send a user message and get the AI response.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _streamSubscription?.cancel();

    var convId = state.conversationId;
    if (convId == null) {
      final conv = _conversationRepository.create(
        title: text.length > 40 ? '${text.substring(0, 40)}...' : text,
      );
      convId = conv.id;
    }

    final userMessage = AIMessage.user(text);
    final updatedMessages = [...state.messages, userMessage];
    _conversationRepository.addMessage(convId, userMessage);

    emit(state.copyWith(
      conversationId: convId,
      messages: updatedMessages,
      status: AIChatStatus.streaming,
      streamBuffer: '',
    ));

    try {
      final buffer = StringBuffer();

      await for (final chunk in _aiRepository.stream(updatedMessages)) {
        buffer.write(chunk);
        emit(state.copyWith(
          streamBuffer: buffer.toString(),
          status: AIChatStatus.streaming,
        ));
      }

      var assistantMessage = AIMessage.assistant(buffer.toString());

      // Report enrichment: detect if the user query maps to a known report
      // and fetch real data from the function registry.
      final reportMatch = _reportDetector.detect(text);
      if (reportMatch != null && _functionRegistry.has(reportMatch.functionName)) {
        final executed = await _functionRegistry.execute(
          FunctionCall(
            name: reportMatch.functionName,
            arguments: reportMatch.params,
          ),
        );
        if (executed.isExecuted && executed.result is Map<String, dynamic>) {
          assistantMessage = assistantMessage.copyWith(
            metadata: {
              'reportId': reportMatch.reportId,
              'reportData': executed.result,
            },
          );
        }
      }

      final finalMessages = [...updatedMessages, assistantMessage];
      _conversationRepository.addMessage(convId, assistantMessage);

      emit(state.copyWith(
        messages: finalMessages,
        status: AIChatStatus.idle,
        streamBuffer: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AIChatStatus.error,
        errorMessage: e.toString(),
        streamBuffer: '',
      ));
    }
  }

  /// Retry the last user message.
  Future<void> retryLast() async {
    final userMessages = state.messages.where((m) => m.role == MessageRole.user);
    if (userMessages.isEmpty) return;
    final lastUserMsg = userMessages.last;

    // Remove the last assistant message if present.
    final trimmed = List<AIMessage>.from(state.messages);
    if (trimmed.isNotEmpty && trimmed.last.role == MessageRole.assistant) {
      trimmed.removeLast();
    }

    emit(state.copyWith(messages: trimmed));
    await sendMessage(lastUserMsg.content);
  }

  /// Clear the current conversation messages.
  void clearChat() {
    emit(const AIChatState());
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
