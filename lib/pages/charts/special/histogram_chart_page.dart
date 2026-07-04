import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _HistData {
  final double value;
  _HistData(this.value);
}

class HistogramChartPage extends StatefulWidget {
  const HistogramChartPage({super.key});

  @override
  State<HistogramChartPage> createState() => _HistogramChartPageState();
}

class _HistogramChartPageState extends State<HistogramChartPage> {
  double _binInterval = 10;
  bool _showNormalCurve = true;

  final List<_HistData> _data = [
    _HistData(52), _HistData(67), _HistData(74), _HistData(81), _HistData(59),
    _HistData(63), _HistData(90), _HistData(45), _HistData(78), _HistData(55),
    _HistData(68), _HistData(72), _HistData(83), _HistData(61), _HistData(76),
    _HistData(49), _HistData(88), _HistData(57), _HistData(71), _HistData(65),
    _HistData(80), _HistData(54), _HistData(69), _HistData(77), _HistData(62),
    _HistData(85), _HistData(50), _HistData(73), _HistData(66), _HistData(79),
    _HistData(43), _HistData(92), _HistData(58), _HistData(70), _HistData(84),
    _HistData(48), _HistData(75), _HistData(64), _HistData(87), _HistData(53),
    _HistData(60), _HistData(82), _HistData(56), _HistData(91), _HistData(46),
    _HistData(74), _HistData(68), _HistData(86), _HistData(51), _HistData(78),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Histogram Chart',
      currentRoute: RouteNames.histogramChart,
      body: ChartWrapper(
        title: 'Student Exam Score Distribution',
        subtitle: 'Frequency distribution of 50 exam scores',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSlider(
              label: 'Bin Interval:',
              value: _binInterval,
              min: 5,
              max: 25,
              divisions: 4,
              onChanged: (v) => setState(() => _binInterval = v),
            ),
            ConfigSwitch(
              label: 'Normal Curve',
              value: _showNormalCurve,
              onChanged: (v) => setState(() => _showNormalCurve = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Score Range'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Frequency'),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_HistData, double>>[
            HistogramSeries<_HistData, double>(
              dataSource: _data,
              yValueMapper: (d, _) => d.value,
              binInterval: _binInterval,
              showNormalDistributionCurve: _showNormalCurve,
              curveColor: const Color(0xFFEF5350),
              curveDashArray: const <double>[5, 3],
              color: const Color(0xFF42A5F5),
              borderColor: const Color(0xFF1976D2),
              borderWidth: 1,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
                textStyle: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
