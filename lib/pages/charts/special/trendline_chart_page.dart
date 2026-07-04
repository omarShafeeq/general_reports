import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _SalesData {
  final double month;
  final double sales;
  _SalesData(this.month, this.sales);
}

class TrendlineChartPage extends StatefulWidget {
  const TrendlineChartPage({super.key});

  @override
  State<TrendlineChartPage> createState() => _TrendlineChartPageState();
}

class _TrendlineChartPageState extends State<TrendlineChartPage> {
  TrendlineType _trendlineType = TrendlineType.linear;

  static const _typeLabels = <TrendlineType, String>{
    TrendlineType.linear: 'Linear',
    TrendlineType.exponential: 'Exponential',
    TrendlineType.power: 'Power',
    TrendlineType.logarithmic: 'Logarithmic',
    TrendlineType.polynomial: 'Polynomial',
    TrendlineType.movingAverage: 'Moving Average',
  };

  final List<_SalesData> _data = [
    _SalesData(1, 120), _SalesData(2, 135), _SalesData(3, 128),
    _SalesData(4, 152), _SalesData(5, 148), _SalesData(6, 170),
    _SalesData(7, 165), _SalesData(8, 190), _SalesData(9, 182),
    _SalesData(10, 210), _SalesData(11, 198), _SalesData(12, 225),
    _SalesData(13, 240), _SalesData(14, 230), _SalesData(15, 260),
    _SalesData(16, 255), _SalesData(17, 280), _SalesData(18, 290),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Trendline Chart',
      currentRoute: RouteNames.trendlineChart,
      body: ChartWrapper(
        title: 'Monthly Sales with Trendline',
        subtitle: 'Apply different trendline types to observed data',
        configPanel: ChartConfigPanel(
          children: [
            ConfigDropdown<TrendlineType>(
              label: 'Trendline:',
              value: _trendlineType,
              items: _typeLabels.keys.toList(),
              labelBuilder: (t) => _typeLabels[t]!,
              onChanged: (v) => setState(() => _trendlineType = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Month'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Sales (\$K)'),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<_SalesData, double>>[
            LineSeries<_SalesData, double>(
              name: 'Sales',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.sales,
              color: const Color(0xFF1E88E5),
              markerSettings: const MarkerSettings(isVisible: true),
              trendlines: <Trendline>[
                Trendline(
                  type: _trendlineType,
                  name: _typeLabels[_trendlineType],
                  color: const Color(0xFFEF5350),
                  width: 2,
                  dashArray: const <double>[5, 3],
                  polynomialOrder:
                      _trendlineType == TrendlineType.polynomial ? 3 : 2,
                  period:
                      _trendlineType == TrendlineType.movingAverage ? 3 : 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
