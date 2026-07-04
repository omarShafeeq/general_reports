import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _DeviceData {
  final String month;
  final double desktop;
  final double mobile;
  final double tablet;

  _DeviceData(this.month, this.desktop, this.mobile, this.tablet);
}

class StackedColumn100ChartPage extends StatefulWidget {
  const StackedColumn100ChartPage({super.key});

  @override
  State<StackedColumn100ChartPage> createState() =>
      _StackedColumn100ChartPageState();
}

class _StackedColumn100ChartPageState
    extends State<StackedColumn100ChartPage> {
  bool _showDataLabels = false;

  final List<_DeviceData> _data = [
    _DeviceData('Jan', 55, 35, 10),
    _DeviceData('Feb', 52, 37, 11),
    _DeviceData('Mar', 48, 40, 12),
    _DeviceData('Apr', 45, 42, 13),
    _DeviceData('May', 43, 44, 13),
    _DeviceData('Jun', 40, 46, 14),
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
      title: '100% Stacked Column',
      currentRoute: RouteNames.stackedColumn100Chart,
      body: ChartWrapper(
        title: 'Device Usage Distribution',
        subtitle: 'Percentage share of traffic by device type',
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
            labelFormat: '{value}%',
            minimum: 0,
            maximum: 100,
          ),
          tooltipBehavior: _tooltipBehavior,
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<_DeviceData, String>>[
            StackedColumn100Series<_DeviceData, String>(
              name: 'Desktop',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.desktop,
              color: const Color(0xFF5C6BC0),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedColumn100Series<_DeviceData, String>(
              name: 'Mobile',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.mobile,
              color: const Color(0xFF26A69A),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedColumn100Series<_DeviceData, String>(
              name: 'Tablet',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.tablet,
              color: const Color(0xFFEF5350),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
          ],
        ),
      ),
    );
  }
}
