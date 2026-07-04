import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartAxisPage extends StatefulWidget {
  const ChartAxisPage({super.key});

  @override
  State<ChartAxisPage> createState() => _ChartAxisPageState();
}

class _ChartAxisPageState extends State<ChartAxisPage> {
  int _labelRotation = 0;
  double _interval = 2;

  final List<_CategoryData> _categoryData = const [
    _CategoryData('Phones', 78),
    _CategoryData('Tablets', 55),
    _CategoryData('Laptops', 65),
    _CategoryData('Monitors', 42),
    _CategoryData('Printers', 30),
    _CategoryData('Cameras', 48),
  ];

  final List<_NumericData> _numericData = const [
    _NumericData(1, 20),
    _NumericData(2, 35),
    _NumericData(3, 28),
    _NumericData(4, 45),
    _NumericData(5, 38),
    _NumericData(6, 52),
    _NumericData(7, 48),
    _NumericData(8, 60),
  ];

  final List<_DateData> _dateData = [
    _DateData(DateTime(2024, 1), 120),
    _DateData(DateTime(2024, 3), 150),
    _DateData(DateTime(2024, 5), 180),
    _DateData(DateTime(2024, 7), 210),
    _DateData(DateTime(2024, 9), 195),
    _DateData(DateTime(2024, 11), 230),
  ];

  final List<_LogData> _logData = const [
    _LogData(1, 10),
    _LogData(2, 100),
    _LogData(3, 500),
    _LogData(5, 1000),
    _LogData(10, 5000),
    _LogData(20, 10000),
    _LogData(50, 50000),
  ];

  final List<_MultiAxisData> _multiAxisData = const [
    _MultiAxisData('Q1', 35, 4.2),
    _MultiAxisData('Q2', 42, 3.8),
    _MultiAxisData('Q3', 38, 5.1),
    _MultiAxisData('Q4', 50, 4.6),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Chart Axis Types',
      currentRoute: RouteNames.chartAxis,
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SizedBox(
            height: 340,
            child: ChartWrapper(
              title: 'CategoryAxis',
              subtitle: 'String-based categories with label rotation',
              configPanel: ChartConfigPanel(children: [
                ConfigDropdown<int>(
                  label: 'Rotation',
                  value: _labelRotation,
                  items: const [0, 45, 90],
                  onChanged: (v) => setState(() => _labelRotation = v),
                  labelBuilder: (v) => '$v°',
                ),
              ]),
              chart: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: _labelRotation,
                  title: const AxisTitle(text: 'Product'),
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Units Sold'),
                ),
                series: <CartesianSeries<_CategoryData, String>>[
                  ColumnSeries<_CategoryData, String>(
                    dataSource: _categoryData,
                    xValueMapper: (d, _) => d.category,
                    yValueMapper: (d, _) => d.value,
                    color: const Color(0xFF1565C0),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 340,
            child: ChartWrapper(
              title: 'NumericAxis',
              subtitle: 'Custom interval and format',
              configPanel: ChartConfigPanel(children: [
                ConfigSlider(
                  label: 'Interval',
                  value: _interval,
                  min: 1,
                  max: 4,
                  divisions: 3,
                  onChanged: (v) => setState(() => _interval = v),
                ),
              ]),
              chart: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  interval: _interval,
                  title: const AxisTitle(text: 'X Value'),
                ),
                primaryYAxis: const NumericAxis(
                  labelFormat: '{value}%',
                  title: AxisTitle(text: 'Percentage'),
                ),
                series: <CartesianSeries<_NumericData, num>>[
                  SplineSeries<_NumericData, num>(
                    dataSource: _numericData,
                    xValueMapper: (d, _) => d.x,
                    yValueMapper: (d, _) => d.y,
                    color: const Color(0xFF00897B),
                    width: 2.5,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 6,
                      width: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 340,
            child: ChartWrapper(
              title: 'DateTimeAxis',
              subtitle: 'Auto date labels with format',
              chart: SfCartesianChart(
                primaryXAxis: const DateTimeAxis(
                  intervalType: DateTimeIntervalType.months,
                  interval: 2,
                  title: AxisTitle(text: 'Date'),
                ),
                primaryYAxis: const NumericAxis(
                  labelFormat: '\${value}',
                  title: AxisTitle(text: 'Revenue'),
                ),
                series: <CartesianSeries<_DateData, DateTime>>[
                  AreaSeries<_DateData, DateTime>(
                    dataSource: _dateData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.value,
                    color: const Color(0xFFF57C00).withOpacity(0.4),
                    borderColor: const Color(0xFFF57C00),
                    borderWidth: 2,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 340,
            child: ChartWrapper(
              title: 'LogarithmicAxis',
              subtitle: 'Logarithmic scale for exponential data',
              chart: SfCartesianChart(
                primaryXAxis: const NumericAxis(
                  title: AxisTitle(text: 'Input'),
                ),
                primaryYAxis: const LogarithmicAxis(
                  title: AxisTitle(text: 'Output (log scale)'),
                ),
                series: <CartesianSeries<_LogData, num>>[
                  LineSeries<_LogData, num>(
                    dataSource: _logData,
                    xValueMapper: (d, _) => d.x,
                    yValueMapper: (d, _) => d.y,
                    color: const Color(0xFF8E24AA),
                    width: 2.5,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 8,
                      width: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 380,
            child: ChartWrapper(
              title: 'Multi-Axis Chart',
              subtitle: 'Primary Y axis + secondary Y axis',
              chart: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: const NumericAxis(
                  name: 'Revenue',
                  title: AxisTitle(text: 'Revenue (K)'),
                  labelFormat: '{value}K',
                ),
                axes: const <ChartAxis>[
                  NumericAxis(
                    name: 'Rating',
                    opposedPosition: true,
                    title: AxisTitle(text: 'Rating'),
                    minimum: 0,
                    maximum: 6,
                    interval: 1,
                  ),
                ],
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                series: <CartesianSeries<_MultiAxisData, String>>[
                  ColumnSeries<_MultiAxisData, String>(
                    name: 'Revenue',
                    dataSource: _multiAxisData,
                    xValueMapper: (d, _) => d.quarter,
                    yValueMapper: (d, _) => d.revenue,
                    yAxisName: 'Revenue',
                    color: const Color(0xFF1565C0),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                  LineSeries<_MultiAxisData, String>(
                    name: 'Rating',
                    dataSource: _multiAxisData,
                    xValueMapper: (d, _) => d.quarter,
                    yValueMapper: (d, _) => d.rating,
                    yAxisName: 'Rating',
                    color: const Color(0xFFD81B60),
                    width: 3,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 8,
                      width: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _CategoryData {
  final String category;
  final double value;
  const _CategoryData(this.category, this.value);
}

class _NumericData {
  final double x;
  final double y;
  const _NumericData(this.x, this.y);
}

class _DateData {
  final DateTime date;
  final double value;
  _DateData(this.date, this.value);
}

class _LogData {
  final double x;
  final double y;
  const _LogData(this.x, this.y);
}

class _MultiAxisData {
  final String quarter;
  final double revenue;
  final double rating;
  const _MultiAxisData(this.quarter, this.revenue, this.rating);
}
