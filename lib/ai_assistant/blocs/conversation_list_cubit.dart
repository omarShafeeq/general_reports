import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/conversation_repository.dart';
import 'conversation_list_state.dart';

/// Manages the list of conversations: create, rename, delete, pin, favorite,
/// search, and refresh.
class ConversationListCubit extends Cubit<ConversationListState> {
  final ConversationRepository _repository;

  ConversationListCubit({required ConversationRepository repository})
      : _repository = repository,
        super(const ConversationListState());

  void refresh() {
    emit(state.copyWith(conversations: _repository.getAll()));
  }

  String createConversation({String title = 'New Conversation'}) {
    final conv = _repository.create(title: title);
    refresh();
    return conv.id;
  }

  void rename(String id, String newTitle) {
    _repository.rename(id, newTitle);
    refresh();
  }

  void delete(String id) {
    _repository.delete(id);
    refresh();
  }

  void togglePin(String id) {
    _repository.togglePin(id);
    refresh();
  }

  void toggleFavorite(String id) {
    _repository.toggleFavorite(id);
    refresh();
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
