import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/core/extensions/context_extensions.dart';
import 'package:general_reports/utils/responsive_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/models.dart';

class PivotChart extends StatelessWidget {
  final PivotResult result;
  final PivotChartType chartType;

  const PivotChart({
    super.key,
    required this.result,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    final chartHeight = context.isMobile
        ? ResponsiveUtils.chartHeight(context)
        : context.isTablet
            ? AppSizes.chartMinHeight + 80
            : AppSizes.chartMaxHeight;

    return Container(
      height: chartHeight,
      padding: EdgeInsets.all(context.isMobile ? AppSizes.sm : AppSizes.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: _buildChart(theme),
    );
  }

  Widget _buildChart(ThemeData theme) {
    switch (chartType) {
      case PivotChartType.bar:
        return _buildCartesianChart(theme, isBar: true);
      case PivotChartType.line:
        return _buildCartesianChart(theme, isLine: true);
      case PivotChartType.area:
        return _buildCartesianChart(theme, isArea: true);
      case PivotChartType.pie:
        return _buildCircularChart(theme, isDoughnut: false);
      case PivotChartType.doughnut:
        return _buildCircularChart(theme, isDoughnut: true);
    }
  }

  Widget _buildCartesianChart(
    ThemeData theme, {
    bool isBar = false,
    bool isLine = false,
    bool isArea = false,
  }) {
    final data = _chartData;
    if (data.isEmpty) return const SizedBox.shrink();

    final valueKeys = data.first.values.keys.toList();
    final palette = _palette(theme, valueKeys.length);

    List<CartesianSeries<_PivotChartData, String>> series;

    if (isLine) {
      series = valueKeys.asMap().entries.map((e) {
        return LineSeries<_PivotChartData, String>(
          name: e.value,
          dataSource: data,
          xValueMapper: (d, _) => d.label,
          yValueMapper: (d, _) => d.values[e.value] ?? 0,
          color: palette[e.key % palette.length],
          markerSettings: const MarkerSettings(isVisible: true, height: 4, width: 4),
        );
      }).toList();
    } else if (isArea) {
      series = valueKeys.asMap().entries.map((e) {
        return AreaSeries<_PivotChartData, String>(
          name: e.value,
          dataSource: data,
          xValueMapper: (d, _) => d.label,
          yValueMapper: (d, _) => d.values[e.value] ?? 0,
          color: palette[e.key % palette.length].withAlpha(150),
          borderColor: palette[e.key % palette.length],
          borderWidth: 2,
        );
      }).toList();
    } else {
      series = valueKeys.asMap().entries.map((e) {
        return ColumnSeries<_PivotChartData, String>(
          name: e.value,
          dataSource: data,
          xValueMapper: (d, _) => d.label,
          yValueMapper: (d, _) => d.values[e.value] ?? 0,
          color: palette[e.key % palette.length],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        );
      }).toList();
    }

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        labelRotation: -45,
        labelStyle: TextStyle(fontSize: 10),
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        labelStyle: TextStyle(fontSize: 10),
      ),
      legend: Legend(
        isVisible: valueKeys.length > 1,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: series,
    );
  }

  Widget _buildCircularChart(ThemeData theme, {required bool isDoughnut}) {
    final data = _chartData;
    if (data.isEmpty) return const SizedBox.shrink();

    final firstValueKey = data.first.values.keys.first;
    final palette = _palette(theme, data.length);

    return SfCircularChart(
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.right,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: [
        if (isDoughnut)
          DoughnutSeries<_PivotChartData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.label,
            yValueMapper: (d, _) => d.values[firstValueKey] ?? 0,
            pointColorMapper: (_, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(fontSize: 10),
            ),
            innerRadius: '60%',
          )
        else
          PieSeries<_PivotChartData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.label,
            yValueMapper: (d, _) => d.values[firstValueKey] ?? 0,
            pointColorMapper: (_, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(fontSize: 10),
            ),
          ),
      ],
    );
  }

  List<_PivotChartData> get _chartData {
    return result.rows.map((row) {
      return _PivotChartData(
        label: row.displayKey,
        values: Map<String, double>.from(row.values),
      );
    }).toList();
  }

  List<Color> _palette(ThemeData theme, int count) {
    final base = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.error,
      Colors.teal,
      Colors.orange,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];
    while (base.length < count) {
      base.addAll(base.map((c) => c.withAlpha(180)));
    }
    return base;
  }
}

class _PivotChartData {
  final String label;
  final Map<String, double> values;

  const _PivotChartData({required this.label, required this.values});
}
