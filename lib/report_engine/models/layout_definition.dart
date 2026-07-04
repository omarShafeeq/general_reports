import 'package:equatable/equatable.dart';

class LayoutDefinition extends Equatable {
  final int desktopColumns;
  final int tabletColumns;
  final int mobileColumns;
  final double spacing;
  final double runSpacing;
  final List<LayoutWidgetConfig> widgets;

  const LayoutDefinition({
    this.desktopColumns = 2,
    this.tabletColumns = 2,
    this.mobileColumns = 1,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.widgets = const [],
  });

  int columnsForWidth(double width) {
    if (width >= 1200) return desktopColumns;
    if (width >= 600) return tabletColumns;
    return mobileColumns;
  }

  @override
  List<Object?> get props => [
        desktopColumns, tabletColumns, mobileColumns,
        spacing, runSpacing, widgets,
      ];
}

class LayoutWidgetConfig extends Equatable {
  final String widgetId;
  final int columnSpan;
  final int order;
  final double? minHeight;
  final double? maxHeight;

  const LayoutWidgetConfig({
    required this.widgetId,
    this.columnSpan = 1,
    this.order = 0,
    this.minHeight,
    this.maxHeight,
  });

  @override
  List<Object?> get props => [widgetId, columnSpan, order, minHeight, maxHeight];
}
