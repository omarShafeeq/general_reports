import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/conversation_list_cubit.dart';
import '../blocs/conversation_list_state.dart';
import '../models/conversation.dart';

/// Sidebar listing all conversations with search, pin, favorite, rename, and
/// delete support.
class ConversationSidebar extends StatefulWidget {
  final void Function(String conversationId) onConversationSelected;

  const ConversationSidebar({
    super.key,
    required this.onConversationSelected,
  });

  @override
  State<ConversationSidebar> createState() => _ConversationSidebarState();
}

class _ConversationSidebarState extends State<ConversationSidebar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ConversationListCubit>().search('');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              context.read<ConversationListCubit>().search(value);
              setState(() {});
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: BlocBuilder<ConversationListCubit, ConversationListState>(
            builder: (context, state) {
              final conversations = state.filtered;

              if (conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        'No conversations yet',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  return _ConversationTile(
                    conversation: conv,
                    onTap: () => widget.onConversationSelected(conv.id),
                    onRename: () => _showRenameDialog(context, conv),
                    onDelete: () {
                      context.read<ConversationListCubit>().delete(conv.id);
                    },
                    onTogglePin: () {
                      context.read<ConversationListCubit>().togglePin(conv.id);
                    },
                    onToggleFavorite: () {
                      context
                          .read<ConversationListCubit>()
                          .toggleFavorite(conv.id);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showRenameDialog(BuildContext context, Conversation conv) {
    final controller = TextEditingController(text: conv.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Conversation'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                context
                    .read<ConversationListCubit>()
                    .rename(conv.id, newTitle);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
    controller.dispose;
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleFavorite;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
    required this.onTogglePin,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = conversation.messages.isNotEmpty
        ? conversation.messages.last.content
        : 'No messages';

    return ListTile(
      dense: true,
      leading: Icon(
        conversation.isPinned ? Icons.push_pin : Icons.chat_bubble_outline,
        size: 20,
        color: conversation.isPinned
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (conversation.isFavorite)
            Icon(Icons.star, size: 16, color: theme.colorScheme.tertiary),
        ],
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: onTap,
      trailing: PopupMenuButton<String>(
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'pin',
            child: Row(
              children: [
                Icon(
                  conversation.isPinned
                      ? Icons.push_pin_outlined
                      : Icons.push_pin,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(conversation.isPinned ? 'Unpin' : 'Pin'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'favorite',
            child: Row(
              children: [
                Icon(
                  conversation.isFavorite
                      ? Icons.star_outline
                      : Icons.star,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(conversation.isFavorite
                    ? 'Remove favorite'
                    : 'Favorite'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'rename',
            child: Row(
              children: [
                Icon(Icons.edit, size: 18),
                SizedBox(width: 8),
                Text('Rename'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 18),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'pin':
              onTogglePin();
            case 'favorite':
              onToggleFavorite();
            case 'rename':
              onRename();
            case 'delete':
              onDelete();
          }
        },
      ),
    );
  }
}
