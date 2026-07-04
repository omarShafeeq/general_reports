import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/routing/route_names.dart';

class _DefectData {
  final String category;
  final int count;
  _DefectData(this.category, this.count);
}

class _ParetoPoint {
  final String category;
  final double cumulativePercent;
  _ParetoPoint(this.category, this.cumulativePercent);
}

class ParetoChartPage extends StatefulWidget {
  const ParetoChartPage({super.key});

  @override
  State<ParetoChartPage> createState() => _ParetoChartPageState();
}

class _ParetoChartPageState extends State<ParetoChartPage> {
  late final List<_DefectData> _defects;
  late final List<_ParetoPoint> _cumulativeData;

  @override
  void initState() {
    super.initState();

    final raw = <_DefectData>[
      _DefectData('UI Bugs', 142),
      _DefectData('API Errors', 98),
      _DefectData('Performance', 75),
      _DefectData('Security', 52),
      _DefectData('Data Loss', 38),
      _DefectData('Crash', 30),
      _DefectData('UX Issues', 22),
      _DefectData('Docs', 15),
    ];

    raw.sort((a, b) => b.count.compareTo(a.count));
    _defects = raw;

    final total = _defects.fold<int>(0, (sum, d) => sum + d.count);
    double running = 0;
    _cumulativeData = _defects.map((d) {
      running += d.count;
      return _ParetoPoint(d.category, (running / total) * 100);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Pareto Chart',
      currentRoute: RouteNames.paretoChart,
      body: ChartWrapper(
        title: 'Defect Category Pareto Analysis',
        subtitle: 'Sorted defect counts with cumulative percentage line',
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Defect Category'),
            labelIntersectAction: AxisLabelIntersectAction.rotate45,
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Count'),
            name: 'countAxis',
          ),
          axes: const <ChartAxis>[
            NumericAxis(
              name: 'percentAxis',
              opposedPosition: true,
              title: AxisTitle(text: 'Cumulative %'),
              minimum: 0,
              maximum: 105,
              interval: 25,
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<dynamic, String>>[
            ColumnSeries<_DefectData, String>(
              name: 'Defect Count',
              dataSource: _defects,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.count,
              yAxisName: 'countAxis',
              color: const Color(0xFF5B8DEF),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
                textStyle: TextStyle(fontSize: 10),
              ),
            ),
            LineSeries<_ParetoPoint, String>(
              name: 'Cumulative %',
              dataSource: _cumulativeData,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.cumulativePercent,
              yAxisName: 'percentAxis',
              color: const Color(0xFFEF5350),
              width: 2,
              markerSettings: const MarkerSettings(
                isVisible: true,
                shape: DataMarkerType.circle,
                width: 8,
                height: 8,
              ),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
                textStyle: TextStyle(fontSize: 9),
              ),
              dataLabelMapper: (d, _) => '${d.cumulativePercent.toStringAsFixed(0)}%',
            ),
          ],
        ),
      ),
    );
  }
}
