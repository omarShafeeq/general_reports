import 'package:flutter/material.dart';

/// Provides the active route name to descendants (e.g. [ChartWrapper]).
class CurrentRouteScope extends InheritedWidget {
  final String routeName;

  const CurrentRouteScope({
    super.key,
    required this.routeName,
    required super.child,
  });

  static CurrentRouteScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CurrentRouteScope>();
  }

  @override
  bool updateShouldNotify(CurrentRouteScope oldWidget) {
    return routeName != oldWidget.routeName;
  }
}
