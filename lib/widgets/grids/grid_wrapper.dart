import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/core/extensions/l10n_extensions.dart';
import 'package:general_reports/core/scope/current_route_scope.dart';

/// Wraps a Syncfusion DataGrid with a title bar and standard states.
class GridWrapper extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget grid;
  final Widget? toolbar;
  final bool isLoading;
  final String? errorMessage;
  final List<Widget>? actions;

  const GridWrapper({
    super.key,
    required this.title,
    required this.grid,
    this.subtitle,
    this.toolbar,
    this.isLoading = false,
    this.errorMessage,
    this.actions,
  });

  String _resolveTitle(BuildContext context) {
    final route = CurrentRouteScope.maybeOf(context)?.routeName;
    if (route != null) {
      return context.l10n.pageTitle(route);
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTitle = _resolveTitle(context);    return Card(
      margin: const EdgeInsets.all(AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md, AppSizes.md, AppSizes.sm, 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayTitle, style: theme.textTheme.titleMedium),                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
          if (toolbar != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, vertical: AppSizes.sm,
              ),
              child: toolbar!,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: _buildBody(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: TextStyle(color: theme.colorScheme.error)),
      );
    }
    return grid;
  }
}
