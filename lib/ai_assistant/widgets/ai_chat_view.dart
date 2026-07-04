import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:syncfusion_flutter_chat/assist_view.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/ai_chat_cubit.dart';
import '../blocs/ai_chat_state.dart';
import '../blocs/conversation_list_cubit.dart';
import '../config/inline_report_configs.dart';
import '../models/ai_message.dart';
import 'ai_placeholder.dart';
import 'report_response_card.dart';

/// Wraps [SfAIAssistView] and binds it to [AIChatCubit].
///
/// Renders response messages as markdown with syntax-highlighted code blocks,
/// streaming text, copy / retry toolbar items, and suggested prompts.
class AIChatView extends StatefulWidget {
  const AIChatView({super.key});

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  List<AssistMessage> _assistMessages = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AIChatCubit, AIChatState>(
      listener: (context, state) {
        _rebuildAssistMessages(state);

        if (state.status == AIChatStatus.idle && state.messages.isNotEmpty) {
          context.read<ConversationListCubit>().refresh();
        }
      },
      builder: (context, state) {
        if (state.isEmpty && state.status == AIChatStatus.idle) {
          return AIPlaceholder(
            onSuggestionTap: (prompt) {
              context.read<AIChatCubit>().sendMessage(prompt);
            },
          );
        }

        return SfAIAssistView(
          messages: _assistMessages,
          composer: AssistComposer(
            decoration: InputDecoration(
              hintText: 'Ask about your data...',
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
            ),
          ),
          actionButton: AssistActionButton(
            onPressed: (String data) {
              context.read<AIChatCubit>().sendMessage(data);
            },
          ),
          placeholderBuilder: (_) => AIPlaceholder(
            onSuggestionTap: (prompt) {
              context.read<AIChatCubit>().sendMessage(prompt);
            },
          ),
          placeholderBehavior: AssistPlaceholderBehavior.hideOnMessage,
          responseToolbarSettings: const AssistMessageToolbarSettings(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          onToolbarItemSelected: (bool selected, int messageIndex,
              AssistMessageToolbarItem item, int toolbarItemIndex) {
            _handleToolbarAction(messageIndex, toolbarItemIndex);
          },
          messageContentBuilder:
              (BuildContext ctx, int index, AssistMessage message) {
            if (message.isRequested) {
              return Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Text(message.data),
              );
            }

            final aiMsg = _findAIMessageForIndex(index, state);
            final reportId = aiMsg?.metadata['reportId'] as String?;
            final reportData =
                aiMsg?.metadata['reportData'] as Map<String, dynamic>?;

            if (reportId != null && reportData != null) {
              final reportDef = InlineReportConfigs.all[reportId];
              if (reportDef != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MarkdownResponseContent(content: message.data),
                    ReportResponseCard(
                      report: reportDef,
                      data: reportData,
                    ),
                  ],
                );
              }
            }

            return _MarkdownResponseContent(content: message.data);
          },
        );
      },
    );
  }

  void _rebuildAssistMessages(AIChatState state) {
    final messages = <AssistMessage>[];

    for (final msg in state.messages) {
      if (msg.role == MessageRole.user) {
        messages.add(AssistMessage.request(
          data: msg.content,
          time: msg.timestamp,
        ));
      } else if (msg.role == MessageRole.assistant) {
        messages.add(_buildResponseMessage(msg));
      }
    }

    if (state.status == AIChatStatus.streaming &&
        state.streamBuffer.isNotEmpty) {
      messages.add(AssistMessage.response(
        data: state.streamBuffer,
        time: DateTime.now(),
      ));
    }

    setState(() {
      _assistMessages = messages;
    });
  }

  /// Maps a SfAIAssistView message index back to the corresponding [AIMessage]
  /// so we can read report metadata attached by the cubit.
  AIMessage? _findAIMessageForIndex(int assistIndex, AIChatState state) {
    if (assistIndex < 0 || assistIndex >= _assistMessages.length) return null;

    // Count through state.messages keeping a running index that mirrors how
    // _rebuildAssistMessages maps AIMessages to AssistMessages.
    int runningIndex = 0;
    for (final msg in state.messages) {
      if (msg.role == MessageRole.system) continue;
      if (runningIndex == assistIndex) return msg;
      runningIndex++;
    }
    return null;
  }

  void _handleToolbarAction(int messageIndex, int toolbarItemIndex) {
    if (messageIndex < 0 || messageIndex >= _assistMessages.length) return;
    final message = _assistMessages[messageIndex];

    switch (toolbarItemIndex) {
      case 0: // Copy
        Clipboard.setData(ClipboardData(text: message.data));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to clipboard'),
            duration: Duration(seconds: 1),
          ),
        );
      case 1: // Retry
        context.read<AIChatCubit>().retryLast();
    }
  }

  AssistMessage _buildResponseMessage(AIMessage msg) {
    return AssistMessage.response(
      data: msg.content,
      time: msg.timestamp,
      toolbarItems: const [
        AssistMessageToolbarItem(
          content: Icon(Icons.copy, size: 16),
          tooltip: 'Copy',
        ),
        AssistMessageToolbarItem(
          content: Icon(Icons.refresh, size: 16),
          tooltip: 'Retry',
        ),
      ],
    );
  }
}

/// Renders markdown content with theme-aware styling and code block
/// highlighting.
class _MarkdownResponseContent extends StatelessWidget {
  final String content;

  const _MarkdownResponseContent({required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: theme.textTheme.bodyMedium,
        h1: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        h2: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        h3: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        code: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: isDark
              ? theme.colorScheme.surfaceContainerHigh
              : theme.colorScheme.surfaceContainerLow,
        ),
        codeblockDecoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surfaceContainerHigh
              : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withAlpha(100),
          ),
        ),
        codeblockPadding: const EdgeInsets.all(AppSizes.sm),
        tableBorder: TableBorder.all(
          color: theme.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        tableHead: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        tableCellsPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.colorScheme.primary,
              width: 3,
            ),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(left: AppSizes.md),
        listBullet: theme.textTheme.bodyMedium,
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          Clipboard.setData(ClipboardData(text: href));
        }
      },
    );
  }
}
