import 'package:flutter/material.dart';

import '../models/layout_definition.dart';

class ResponsiveReportLayout extends StatelessWidget {
  final LayoutDefinition layout;
  final List<Widget> children;
  final Map<int, int> spanOverrides;

  const ResponsiveReportLayout({
    super.key,
    required this.layout,
    required this.children,
    this.spanOverrides = const {},
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = layout.columnsForWidth(constraints.maxWidth);

        if (columns <= 1) {
          return _buildSingleColumn();
        }

        return _buildMultiColumn(columns, constraints.maxWidth);
      },
    );
  }

  Widget _buildSingleColumn() {
    return ListView.builder(
      padding: EdgeInsets.all(layout.spacing),
      itemCount: children.length,
      itemBuilder: (context, index) {
        final widgetConfig = index < layout.widgets.length
            ? layout.widgets[index]
            : null;

        return Padding(
          padding: EdgeInsets.only(bottom: layout.runSpacing),
          child: _constrainHeight(children[index], widgetConfig),
        );
      },
    );
  }

  Widget _buildMultiColumn(int columns, double maxWidth) {
    final cellWidth =
        (maxWidth - layout.spacing * (columns + 1)) / columns;

    final rows = <List<_LayoutCell>>[];
    var currentRow = <_LayoutCell>[];
    var currentRowSpan = 0;

    for (var i = 0; i < children.length; i++) {
      final widgetConfig = i < layout.widgets.length
          ? layout.widgets[i]
          : null;
      final span = spanOverrides[i] ??
          widgetConfig?.columnSpan ??
          1;
      final effectiveSpan = span.clamp(1, columns);

      if (currentRowSpan + effectiveSpan > columns && currentRow.isNotEmpty) {
        rows.add(currentRow);
        currentRow = [];
        currentRowSpan = 0;
      }

      currentRow.add(_LayoutCell(
        widget: children[i],
        span: effectiveSpan,
        config: widgetConfig,
      ));
      currentRowSpan += effectiveSpan;

      if (currentRowSpan >= columns) {
        rows.add(currentRow);
        currentRow = [];
        currentRowSpan = 0;
      }
    }

    if (currentRow.isNotEmpty) {
      rows.add(currentRow);
    }

    return ListView.builder(
      padding: EdgeInsets.all(layout.spacing),
      itemCount: rows.length,
      itemBuilder: (context, rowIndex) {
        final row = rows[rowIndex];
        return Padding(
          padding: EdgeInsets.only(bottom: layout.runSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: row.map((cell) {
              final width = cellWidth * cell.span +
                  layout.spacing * (cell.span - 1);
              return Padding(
                padding: EdgeInsets.only(
                  right: cell != row.last ? layout.spacing : 0,
                ),
                child: SizedBox(
                  width: width,
                  child: _constrainHeight(cell.widget, cell.config),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _constrainHeight(Widget child, LayoutWidgetConfig? config) {
    if (config == null) return child;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: config.minHeight ?? 0,
        maxHeight: config.maxHeight ?? double.infinity,
      ),
      child: child,
    );
  }
}

class _LayoutCell {
  final Widget widget;
  final int span;
  final LayoutWidgetConfig? config;

  const _LayoutCell({
    required this.widget,
    required this.span,
    this.config,
  });
}
