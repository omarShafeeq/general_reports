import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _SalesData {
  final String month;
  final double revenue;

  _SalesData(this.month, this.revenue);
}

class ColumnChartPage extends StatefulWidget {
  const ColumnChartPage({super.key});

  @override
  State<ColumnChartPage> createState() => _ColumnChartPageState();
}

class _ColumnChartPageState extends State<ColumnChartPage> {
  bool _showDataLabels = false;
  bool _roundedCorners = true;
  bool _showGradient = true;
  double _spacing = 0.2;

  final List<_SalesData> _data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 42),
    _SalesData('Apr', 50),
    _SalesData('May', 38),
    _SalesData('Jun', 55),
    _SalesData('Jul', 47),
    _SalesData('Aug', 62),
    _SalesData('Sep', 58),
    _SalesData('Oct', 44),
    _SalesData('Nov', 51),
    _SalesData('Dec', 68),
  ];

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveScaffold(
      title: 'Column Chart',
      currentRoute: RouteNames.columnChart,
      body: ChartWrapper(
        title: 'Monthly Revenue',
        subtitle: 'Revenue performance across months (in thousands)',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Data Labels',
              value: _showDataLabels,
              onChanged: (v) => setState(() => _showDataLabels = v),
            ),
            ConfigSwitch(
              label: 'Rounded',
              value: _roundedCorners,
              onChanged: (v) => setState(() => _roundedCorners = v),
            ),
            ConfigSwitch(
              label: 'Gradient',
              value: _showGradient,
              onChanged: (v) => setState(() => _showGradient = v),
            ),
            ConfigSlider(
              label: 'Spacing',
              value: _spacing,
              min: 0,
              max: 0.5,
              divisions: 10,
              onChanged: (v) => setState(() => _spacing = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            labelFormat: '\${value}K',
          ),
          tooltipBehavior: _tooltipBehavior,
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<_SalesData, String>>[
            ColumnSeries<_SalesData, String>(
              name: 'Revenue',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.revenue,
              spacing: _spacing,
              width: 0.8,
              borderRadius: _roundedCorners
                  ? const BorderRadius.vertical(top: Radius.circular(6))
                  : BorderRadius.zero,
              gradient: _showGradient
                  ? LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        colorScheme.primary.withAlpha(160),
                        colorScheme.primary,
                      ],
                    )
                  : null,
              color: _showGradient ? null : colorScheme.primary,
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
          ],
        ),
      ),
    );
  }
}
