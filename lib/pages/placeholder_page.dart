import 'package:flutter/material.dart';
import 'package:general_reports/core/extensions/l10n_extensions.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  final String routeName;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final displayTitle = l10n.pageTitle(routeName);
    return ResponsiveScaffold(
      title: title,
      currentRoute: routeName,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              displayTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.comingSoon,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
