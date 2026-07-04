import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _BoxData {
  final String department;
  final List<num> values;
  _BoxData(this.department, this.values);
}

class BoxWhiskerChartPage extends StatefulWidget {
  const BoxWhiskerChartPage({super.key});

  @override
  State<BoxWhiskerChartPage> createState() => _BoxWhiskerChartPageState();
}

class _BoxWhiskerChartPageState extends State<BoxWhiskerChartPage> {
  bool _showMean = true;
  double _boxWidth = 0.7;

  final List<_BoxData> _data = [
    _BoxData('Engineering', [42, 55, 67, 48, 73, 61, 80, 50, 64, 59, 71, 45, 88, 53, 76]),
    _BoxData('Marketing', [38, 45, 52, 61, 44, 56, 70, 48, 63, 39, 50, 58, 65, 42, 54]),
    _BoxData('Sales', [55, 68, 47, 72, 85, 60, 78, 53, 91, 66, 74, 58, 83, 49, 70]),
    _BoxData('Finance', [50, 58, 65, 72, 54, 67, 60, 75, 63, 70, 56, 69, 61, 74, 66]),
    _BoxData('HR', [35, 42, 55, 48, 60, 44, 52, 38, 57, 46, 63, 40, 50, 47, 54]),
    _BoxData('Operations', [44, 52, 60, 68, 56, 73, 49, 65, 58, 77, 51, 62, 70, 46, 63]),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Box & Whisker Chart',
      currentRoute: RouteNames.boxWhiskerChart,
      body: ChartWrapper(
        title: 'Employee Performance Scores by Department',
        subtitle: 'Distribution of quarterly performance reviews',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Show Mean',
              value: _showMean,
              onChanged: (v) => setState(() => _showMean = v),
            ),
            ConfigSlider(
              label: 'Box Width:',
              value: _boxWidth,
              min: 0.3,
              max: 1.0,
              divisions: 7,
              onChanged: (v) => setState(() => _boxWidth = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Department'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Performance Score'),
            minimum: 30,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_BoxData, String>>[
            BoxAndWhiskerSeries<_BoxData, String>(
              dataSource: _data,
              xValueMapper: (d, _) => d.department,
              yValueMapper: (d, _) => d.values,
              showMean: _showMean,
              boxPlotMode: BoxPlotMode.normal,
              spacing: 1 - _boxWidth,
              color: const Color(0xFF7E57C2),
              borderColor: const Color(0xFF5E35B1),
            ),
          ],
        ),
      ),
    );
  }
}
