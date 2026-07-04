import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/models/chart_sample_data.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class SplineChartPage extends StatefulWidget {
  const SplineChartPage({super.key});

  @override
  State<SplineChartPage> createState() => _SplineChartPageState();
}

class _SplineChartPageState extends State<SplineChartPage> {
  bool _showMarkers = true;
  bool _showDataLabels = false;
  bool _enableTooltip = true;
  bool _animate = true;
  SplineType _splineType = SplineType.natural;

  final List<ChartSampleData> _temperatureData = const [
    ChartSampleData(x: 'Jan', y: 2, y2: 8),
    ChartSampleData(x: 'Feb', y: 3, y2: 10),
    ChartSampleData(x: 'Mar', y: 7, y2: 14),
    ChartSampleData(x: 'Apr', y: 12, y2: 18),
    ChartSampleData(x: 'May', y: 17, y2: 22),
    ChartSampleData(x: 'Jun', y: 21, y2: 26),
    ChartSampleData(x: 'Jul', y: 23, y2: 29),
    ChartSampleData(x: 'Aug', y: 22, y2: 28),
    ChartSampleData(x: 'Sep', y: 18, y2: 24),
    ChartSampleData(x: 'Oct', y: 13, y2: 18),
    ChartSampleData(x: 'Nov', y: 7, y2: 12),
    ChartSampleData(x: 'Dec', y: 3, y2: 9),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Spline Chart',
      currentRoute: RouteNames.splineChart,
      body: ChartWrapper(
        title: 'Average Temperature Trends',
        subtitle: 'Smooth curves with configurable spline type',
        configPanel: ChartConfigPanel(children: [
          ConfigSwitch(
            label: 'Markers',
            value: _showMarkers,
            onChanged: (v) => setState(() => _showMarkers = v),
          ),
          ConfigSwitch(
            label: 'Data Labels',
            value: _showDataLabels,
            onChanged: (v) => setState(() => _showDataLabels = v),
          ),
          ConfigSwitch(
            label: 'Tooltip',
            value: _enableTooltip,
            onChanged: (v) => setState(() => _enableTooltip = v),
          ),
          ConfigSwitch(
            label: 'Animation',
            value: _animate,
            onChanged: (v) => setState(() => _animate = v),
          ),
          ConfigDropdown<SplineType>(
            label: 'Spline Type',
            value: _splineType,
            items: SplineType.values,
            onChanged: (v) => setState(() => _splineType = v),
            labelBuilder: (t) => t.name,
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            labelFormat: '{value}°C',
            minimum: 0,
            maximum: 35,
            interval: 5,
          ),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<ChartSampleData, String>>[
            SplineSeries<ChartSampleData, String>(
              name: 'London',
              dataSource: _temperatureData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y,
              color: AppColors.chartPalette[0],
              width: 2.5,
              splineType: _splineType,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 6, width: 6),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            SplineSeries<ChartSampleData, String>(
              name: 'Paris',
              dataSource: _temperatureData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y2,
              color: AppColors.chartPalette[2],
              width: 2.5,
              splineType: _splineType,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 6, width: 6),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
