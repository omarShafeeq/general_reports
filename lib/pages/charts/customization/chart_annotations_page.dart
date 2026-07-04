import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartAnnotationsPage extends StatefulWidget {
  const ChartAnnotationsPage({super.key});

  @override
  State<ChartAnnotationsPage> createState() => _ChartAnnotationsPageState();
}

class _ChartAnnotationsPageState extends State<ChartAnnotationsPage> {
  bool _showTextAnnotations = true;
  bool _showIconAnnotations = true;
  CoordinateUnit _coordinateUnit = CoordinateUnit.point;

  final List<_RevenueData> _data = const [
    _RevenueData('Jan', 24),
    _RevenueData('Feb', 28),
    _RevenueData('Mar', 36),
    _RevenueData('Apr', 32),
    _RevenueData('May', 40),
    _RevenueData('Jun', 44),
    _RevenueData('Jul', 48),
    _RevenueData('Aug', 52),
    _RevenueData('Sep', 46),
    _RevenueData('Oct', 56),
    _RevenueData('Nov', 58),
    _RevenueData('Dec', 62),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ResponsiveScaffold(
      title: 'Chart Annotations',
      currentRoute: RouteNames.chartAnnotations,
      body: ChartWrapper(
        title: 'Widget Annotations',
        subtitle: 'Text and icon annotations at data points',
        configPanel: ChartConfigPanel(children: [
          ConfigSwitch(
            label: 'Text Labels',
            value: _showTextAnnotations,
            onChanged: (v) => setState(() => _showTextAnnotations = v),
          ),
          ConfigSwitch(
            label: 'Icon Markers',
            value: _showIconAnnotations,
            onChanged: (v) => setState(() => _showIconAnnotations = v),
          ),
          ConfigDropdown<CoordinateUnit>(
            label: 'Coordinate',
            value: _coordinateUnit,
            items: CoordinateUnit.values,
            onChanged: (v) => setState(() => _coordinateUnit = v),
            labelBuilder: (v) => v.name,
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            maximum: 75,
            interval: 15,
            labelFormat: '\${value}K',
          ),
          annotations: <CartesianChartAnnotation>[
            if (_showTextAnnotations)
              CartesianChartAnnotation(
                widget: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF43A047),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Peak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                coordinateUnit: _coordinateUnit,
                x: 'Dec',
                y: 68,
              ),
            if (_showTextAnnotations)
              CartesianChartAnnotation(
                widget: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Dip',
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                coordinateUnit: _coordinateUnit,
                x: 'Apr',
                y: 27,
              ),
            if (_showIconAnnotations)
              CartesianChartAnnotation(
                widget: const Icon(
                  Icons.star,
                  color: Color(0xFFFFB300),
                  size: 22,
                ),
                coordinateUnit: _coordinateUnit,
                x: 'May',
                y: 46,
              ),
            if (_showIconAnnotations)
              CartesianChartAnnotation(
                widget: Icon(
                  Icons.trending_up,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                coordinateUnit: _coordinateUnit,
                x: 'Oct',
                y: 62,
              ),
          ],
          series: <CartesianSeries<_RevenueData, String>>[
            SplineAreaSeries<_RevenueData, String>(
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.value,
              color: const Color(0xFF1565C0).withOpacity(0.3),
              borderColor: const Color(0xFF1565C0),
              borderWidth: 2.5,
              markerSettings: const MarkerSettings(
                isVisible: true,
                height: 6,
                width: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueData {
  final String month;
  final double value;
  const _RevenueData(this.month, this.value);
}
