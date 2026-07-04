import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant, system }

class AIMessage extends Equatable {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const AIMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.metadata = const {},
  });

  factory AIMessage.user(String content) => AIMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: MessageRole.user,
        content: content,
        timestamp: DateTime.now(),
      );

  factory AIMessage.assistant(String content, {Map<String, dynamic>? metadata}) =>
      AIMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        content: content,
        timestamp: DateTime.now(),
        metadata: metadata ?? const {},
      );

  AIMessage copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return AIMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [id, role, content, timestamp, metadata];
}
