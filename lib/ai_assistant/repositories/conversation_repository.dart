import '../models/ai_message.dart';
import '../models/conversation.dart';

/// In-memory conversation store.
///
/// Designed with an interface-compatible shape so it can later be backed by
/// SharedPreferences, Hive, or SQLite without modifying callers.
class ConversationRepository {
  final List<Conversation> _conversations = [];

  List<Conversation> getAll() => List.unmodifiable(_conversations);

  Conversation? getById(String id) {
    final idx = _conversations.indexWhere((c) => c.id == id);
    return idx >= 0 ? _conversations[idx] : null;
  }

  Conversation create({String title = 'New Conversation'}) {
    final conv = Conversation.create(title: title);
    _conversations.insert(0, conv);
    return conv;
  }

  void update(Conversation conversation) {
    final idx = _conversations.indexWhere((c) => c.id == conversation.id);
    if (idx >= 0) {
      _conversations[idx] = conversation;
    }
  }

  void delete(String id) {
    _conversations.removeWhere((c) => c.id == id);
  }

  void addMessage(String conversationId, AIMessage message) {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx < 0) return;
    final conv = _conversations[idx];
    _conversations[idx] = conv.copyWith(
      messages: [...conv.messages, message],
      updatedAt: DateTime.now(),
    );
  }

  void updateLastMessage(String conversationId, AIMessage message) {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx < 0) return;
    final conv = _conversations[idx];
    if (conv.messages.isEmpty) return;
    final updated = List<AIMessage>.from(conv.messages);
    updated[updated.length - 1] = message;
    _conversations[idx] = conv.copyWith(
      messages: updated,
      updatedAt: DateTime.now(),
    );
  }

  void rename(String id, String newTitle) {
    final idx = _conversations.indexWhere((c) => c.id == id);
    if (idx >= 0) {
      _conversations[idx] = _conversations[idx].copyWith(
        title: newTitle,
        updatedAt: DateTime.now(),
      );
    }
  }

  void togglePin(String id) {
    final idx = _conversations.indexWhere((c) => c.id == id);
    if (idx >= 0) {
      _conversations[idx] = _conversations[idx].copyWith(
        isPinned: !_conversations[idx].isPinned,
        updatedAt: DateTime.now(),
      );
    }
  }

  void toggleFavorite(String id) {
    final idx = _conversations.indexWhere((c) => c.id == id);
    if (idx >= 0) {
      _conversations[idx] = _conversations[idx].copyWith(
        isFavorite: !_conversations[idx].isFavorite,
        updatedAt: DateTime.now(),
      );
    }
  }

  List<Conversation> search(String query) {
    if (query.isEmpty) return getAll();
    final lower = query.toLowerCase();
    return _conversations
        .where((c) =>
            c.title.toLowerCase().contains(lower) ||
            c.messages.any((m) => m.content.toLowerCase().contains(lower)))
        .toList();
  }
}
