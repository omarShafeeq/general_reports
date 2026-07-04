import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _RegionData {
  final String region;
  final double online;
  final double retail;
  final double wholesale;

  _RegionData(this.region, this.online, this.retail, this.wholesale);
}

class StackedBarChartPage extends StatefulWidget {
  const StackedBarChartPage({super.key});

  @override
  State<StackedBarChartPage> createState() => _StackedBarChartPageState();
}

class _StackedBarChartPageState extends State<StackedBarChartPage> {
  bool _showDataLabels = false;

  final List<_RegionData> _data = [
    _RegionData('North', 42, 35, 28),
    _RegionData('South', 38, 40, 22),
    _RegionData('East', 55, 30, 35),
    _RegionData('West', 48, 45, 30),
    _RegionData('Central', 33, 28, 20),
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
      title: 'Stacked Bar Chart',
      currentRoute: RouteNames.stackedBarChart,
      body: ChartWrapper(
        title: 'Regional Sales by Channel',
        subtitle: 'Revenue breakdown per region by sales channel (in thousands)',
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
            labelFormat: '\${value}K',
          ),
          tooltipBehavior: _tooltipBehavior,
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<_RegionData, String>>[
            StackedBarSeries<_RegionData, String>(
              name: 'Online',
              dataSource: _data,
              xValueMapper: (d, _) => d.region,
              yValueMapper: (d, _) => d.online,
              color: const Color(0xFF42A5F5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedBarSeries<_RegionData, String>(
              name: 'Retail',
              dataSource: _data,
              xValueMapper: (d, _) => d.region,
              yValueMapper: (d, _) => d.retail,
              color: const Color(0xFF66BB6A),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedBarSeries<_RegionData, String>(
              name: 'Wholesale',
              dataSource: _data,
              xValueMapper: (d, _) => d.region,
              yValueMapper: (d, _) => d.wholesale,
              color: const Color(0xFFFF7043),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
          ],
        ),
      ),
    );
  }
}
