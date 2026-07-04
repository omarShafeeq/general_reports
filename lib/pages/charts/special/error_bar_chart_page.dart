import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _ErrorBarData {
  final String lab;
  final double mean;
  final double verticalError;
  final double horizontalError;
  _ErrorBarData(this.lab, this.mean, this.verticalError, this.horizontalError);
}

class ErrorBarChartPage extends StatefulWidget {
  const ErrorBarChartPage({super.key});

  @override
  State<ErrorBarChartPage> createState() => _ErrorBarChartPageState();
}

class _ErrorBarChartPageState extends State<ErrorBarChartPage> {
  ErrorBarType _errorType = ErrorBarType.fixed;
  Direction _direction = Direction.both;

  static const _typeLabels = <ErrorBarType, String>{
    ErrorBarType.fixed: 'Fixed',
    ErrorBarType.percentage: 'Percentage',
    ErrorBarType.standardDeviation: 'Std Deviation',
    ErrorBarType.custom: 'Custom',
  };

  static const _directionLabels = <Direction, String>{
    Direction.both: 'Both',
    Direction.plus: 'Plus',
    Direction.minus: 'Minus',
  };

  final List<_ErrorBarData> _data = [
    _ErrorBarData('Lab A', 45, 4.5, 0.8),
    _ErrorBarData('Lab B', 62, 6.1, 1.2),
    _ErrorBarData('Lab C', 38, 3.8, 0.5),
    _ErrorBarData('Lab D', 71, 7.2, 1.5),
    _ErrorBarData('Lab E', 54, 5.5, 1.0),
    _ErrorBarData('Lab F', 83, 8.3, 1.8),
    _ErrorBarData('Lab G', 47, 4.7, 0.9),
    _ErrorBarData('Lab H', 66, 6.6, 1.3),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Error Bar Chart',
      currentRoute: RouteNames.errorBarChart,
      body: ChartWrapper(
        title: 'Laboratory Measurement Error Bars',
        subtitle: 'Mean readings with confidence intervals',
        configPanel: ChartConfigPanel(
          children: [
            ConfigDropdown<ErrorBarType>(
              label: 'Type:',
              value: _errorType,
              items: _typeLabels.keys.toList(),
              labelBuilder: (t) => _typeLabels[t]!,
              onChanged: (v) => setState(() => _errorType = v),
            ),
            ConfigDropdown<Direction>(
              label: 'Direction:',
              value: _direction,
              items: _directionLabels.keys.toList(),
              labelBuilder: (d) => _directionLabels[d]!,
              onChanged: (v) => setState(() => _direction = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Laboratory'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Measurement Value'),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_ErrorBarData, String>>[
            ErrorBarSeries<_ErrorBarData, String>(
              dataSource: _data,
              xValueMapper: (d, _) => d.lab,
              yValueMapper: (d, _) => d.mean,
              type: _errorType,
              direction: _direction,
              verticalErrorValue: 5,
              horizontalErrorValue: 1,
              verticalPositiveErrorValue: 6,
              verticalNegativeErrorValue: 4,
              horizontalPositiveErrorValue: 1.2,
              horizontalNegativeErrorValue: 0.8,
              color: const Color(0xFF5C6BC0),
              width: 2,
              capLength: 10,
            ),
          ],
        ),
      ),
    );
  }
}
