import 'package:equatable/equatable.dart';

import '../models/conversation.dart';

class ConversationListState extends Equatable {
  final List<Conversation> conversations;
  final String searchQuery;

  const ConversationListState({
    this.conversations = const [],
    this.searchQuery = '',
  });

  List<Conversation> get filtered {
    var list = List<Conversation>.from(conversations);

    if (searchQuery.isNotEmpty) {
      final lower = searchQuery.toLowerCase();
      list = list
          .where((c) =>
              c.title.toLowerCase().contains(lower) ||
              c.messages.any((m) => m.content.toLowerCase().contains(lower)))
          .toList();
    }

    // Pinned first, then by updatedAt descending.
    list.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return list;
  }

  ConversationListState copyWith({
    List<Conversation>? conversations,
    String? searchQuery,
  }) {
    return ConversationListState(
      conversations: conversations ?? this.conversations,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [conversations, searchQuery];
}
