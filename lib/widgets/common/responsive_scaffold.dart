import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/core/extensions/l10n_extensions.dart';
import 'package:general_reports/core/scope/current_route_scope.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/navigation_drawer.dart';

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final String currentRoute;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.currentRoute,
    this.actions,
    this.floatingActionButton,
  });

  String _resolvedTitle(BuildContext context) {
    if (currentRoute == RouteNames.home) {
      return context.l10n.appTitle;
    }
    return context.l10n.pageTitle(currentRoute);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppSizes.tabletBreakpoint;
    final localizedTitle = _resolvedTitle(context);

    if (isDesktop) {
      return _DesktopLayout(
        title: localizedTitle,
        body: CurrentRouteScope(
          routeName: currentRoute,
          child: body,
        ),
        currentRoute: currentRoute,
        actions: actions,
        floatingActionButton: floatingActionButton,
      );
    }

    return _MobileLayout(
      title: localizedTitle,
      body: CurrentRouteScope(
        routeName: currentRoute,
        child: body,
      ),
      currentRoute: currentRoute,
      actions: actions,
      floatingActionButton: floatingActionButton,
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final String currentRoute;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const _DesktopLayout({
    required this.title,
    required this.body,
    required this.currentRoute,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: AppSizes.sidebarWidth,
            child: AppNavigationDrawer(currentRoute: currentRoute),
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(title),
                actions: actions,
                automaticallyImplyLeading: false,
              ),
              body: body,
              floatingActionButton: floatingActionButton,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final String currentRoute;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const _MobileLayout({
    required this.title,
    required this.body,
    required this.currentRoute,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      drawer: AppNavigationDrawer(
        currentRoute: currentRoute,
        onClose: () => Navigator.pop(context),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
