import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _TemperatureData {
  final String month;
  final double low;
  final double high;

  _TemperatureData(this.month, this.low, this.high);
}

class RangeColumnChartPage extends StatefulWidget {
  const RangeColumnChartPage({super.key});

  @override
  State<RangeColumnChartPage> createState() => _RangeColumnChartPageState();
}

class _RangeColumnChartPageState extends State<RangeColumnChartPage> {
  bool _showDataLabels = false;

  final List<_TemperatureData> _data = [
    _TemperatureData('Jan', -2, 8),
    _TemperatureData('Feb', -1, 10),
    _TemperatureData('Mar', 3, 14),
    _TemperatureData('Apr', 7, 19),
    _TemperatureData('May', 12, 24),
    _TemperatureData('Jun', 16, 29),
    _TemperatureData('Jul', 19, 33),
    _TemperatureData('Aug', 18, 32),
    _TemperatureData('Sep', 14, 27),
    _TemperatureData('Oct', 9, 20),
    _TemperatureData('Nov', 4, 13),
    _TemperatureData('Dec', 0, 9),
  ];

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Range Column Chart',
      currentRoute: RouteNames.rangeColumnChart,
      body: ChartWrapper(
        title: 'Monthly Temperature Range',
        subtitle: 'Low and high temperature averages throughout the year (°C)',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Data Labels',
              value: _showDataLabels,
              onChanged: (v) => setState(() => _showDataLabels = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            labelFormat: '{value}°C',
          ),
          tooltipBehavior: _tooltipBehavior,
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<_TemperatureData, String>>[
            RangeColumnSeries<_TemperatureData, String>(
              name: 'Temperature',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              lowValueMapper: (d, _) => d.low,
              highValueMapper: (d, _) => d.high,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF42A5F5),
                  Color(0xFFEF5350),
                ],
              ),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
          ],
        ),
      ),
    );
  }
}
