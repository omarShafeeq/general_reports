import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _DepartmentData {
  final String quarter;
  final double engineering;
  final double marketing;
  final double sales;
  final double support;

  _DepartmentData(
    this.quarter,
    this.engineering,
    this.marketing,
    this.sales,
    this.support,
  );
}

class StackedColumnChartPage extends StatefulWidget {
  const StackedColumnChartPage({super.key});

  @override
  State<StackedColumnChartPage> createState() => _StackedColumnChartPageState();
}

class _StackedColumnChartPageState extends State<StackedColumnChartPage> {
  bool _showDataLabels = false;
  String _groupName = 'default';

  final List<_DepartmentData> _data = [
    _DepartmentData('Q1 2024', 45, 28, 35, 18),
    _DepartmentData('Q2 2024', 52, 32, 40, 22),
    _DepartmentData('Q3 2024', 48, 30, 38, 20),
    _DepartmentData('Q4 2024', 60, 35, 45, 25),
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
      title: 'Stacked Column Chart',
      currentRoute: RouteNames.stackedColumnChart,
      body: ChartWrapper(
        title: 'Department Spending by Quarter',
        subtitle: 'Budget allocation across departments (in thousands)',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Data Labels',
              value: _showDataLabels,
              onChanged: (v) => setState(() => _showDataLabels = v),
            ),
            ConfigDropdown<String>(
              label: 'Group',
              value: _groupName,
              items: const ['default', 'group-a', 'group-b'],
              onChanged: (v) => setState(() => _groupName = v),
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
          series: <CartesianSeries<_DepartmentData, String>>[
            StackedColumnSeries<_DepartmentData, String>(
              name: 'Engineering',
              dataSource: _data,
              xValueMapper: (d, _) => d.quarter,
              yValueMapper: (d, _) => d.engineering,
              groupName: _groupName,
              color: const Color(0xFF1565C0),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedColumnSeries<_DepartmentData, String>(
              name: 'Marketing',
              dataSource: _data,
              xValueMapper: (d, _) => d.quarter,
              yValueMapper: (d, _) => d.marketing,
              groupName: _groupName,
              color: const Color(0xFF00897B),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedColumnSeries<_DepartmentData, String>(
              name: 'Sales',
              dataSource: _data,
              xValueMapper: (d, _) => d.quarter,
              yValueMapper: (d, _) => d.sales,
              groupName: _groupName,
              color: const Color(0xFFF57C00),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedColumnSeries<_DepartmentData, String>(
              name: 'Support',
              dataSource: _data,
              xValueMapper: (d, _) => d.quarter,
              yValueMapper: (d, _) => d.support,
              groupName: _groupName,
              color: const Color(0xFF8E24AA),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
          ],
        ),
      ),
    );
  }
}
