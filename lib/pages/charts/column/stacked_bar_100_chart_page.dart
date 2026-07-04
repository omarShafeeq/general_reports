import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _SkillData {
  final String department;
  final double beginner;
  final double intermediate;
  final double advanced;
  final double expert;

  _SkillData(
    this.department,
    this.beginner,
    this.intermediate,
    this.advanced,
    this.expert,
  );
}

class StackedBar100ChartPage extends StatefulWidget {
  const StackedBar100ChartPage({super.key});

  @override
  State<StackedBar100ChartPage> createState() =>
      _StackedBar100ChartPageState();
}

class _StackedBar100ChartPageState extends State<StackedBar100ChartPage> {
  bool _showDataLabels = false;

  final List<_SkillData> _data = [
    _SkillData('Engineering', 10, 25, 40, 25),
    _SkillData('Design', 15, 30, 35, 20),
    _SkillData('Marketing', 20, 35, 30, 15),
    _SkillData('Sales', 25, 30, 30, 15),
    _SkillData('HR', 30, 35, 25, 10),
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
      title: '100% Stacked Bar',
      currentRoute: RouteNames.stackedBar100Chart,
      body: ChartWrapper(
        title: 'Skill Distribution by Department',
        subtitle: 'Percentage of employees at each skill level',
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
          series: <CartesianSeries<_SkillData, String>>[
            StackedBar100Series<_SkillData, String>(
              name: 'Beginner',
              dataSource: _data,
              xValueMapper: (d, _) => d.department,
              yValueMapper: (d, _) => d.beginner,
              color: const Color(0xFFFFCA28),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedBar100Series<_SkillData, String>(
              name: 'Intermediate',
              dataSource: _data,
              xValueMapper: (d, _) => d.department,
              yValueMapper: (d, _) => d.intermediate,
              color: const Color(0xFF29B6F6),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedBar100Series<_SkillData, String>(
              name: 'Advanced',
              dataSource: _data,
              xValueMapper: (d, _) => d.department,
              yValueMapper: (d, _) => d.advanced,
              color: const Color(0xFF66BB6A),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
            StackedBar100Series<_SkillData, String>(
              name: 'Expert',
              dataSource: _data,
              xValueMapper: (d, _) => d.department,
              yValueMapper: (d, _) => d.expert,
              color: const Color(0xFFAB47BC),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
          ],
        ),
      ),
    );
  }
}
