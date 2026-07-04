import 'package:equatable/equatable.dart';

import 'ai_message.dart';

class Conversation extends Equatable {
  final String id;
  final String title;
  final List<AIMessage> messages;
  final bool isPinned;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.title,
    this.messages = const [],
    this.isPinned = false,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.create({String title = 'New Conversation'}) {
    final now = DateTime.now();
    return Conversation(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: now,
      updatedAt: now,
    );
  }

  Conversation copyWith({
    String? id,
    String? title,
    List<AIMessage>? messages,
    bool? isPinned,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, messages, isPinned, isFavorite, createdAt, updatedAt];
}
