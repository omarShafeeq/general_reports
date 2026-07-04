import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/models/chart_sample_data.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class LineChartPage extends StatefulWidget {
  const LineChartPage({super.key});

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  bool _showMarkers = true;
  bool _showDataLabels = false;
  bool _enableTooltip = true;
  bool _animate = true;

  final List<ChartSampleData> _revenueData = const [
    ChartSampleData(x: 'Jan', y: 35, y2: 28, y3: 18),
    ChartSampleData(x: 'Feb', y: 28, y2: 32, y3: 22),
    ChartSampleData(x: 'Mar', y: 34, y2: 30, y3: 20),
    ChartSampleData(x: 'Apr', y: 32, y2: 36, y3: 25),
    ChartSampleData(x: 'May', y: 40, y2: 33, y3: 30),
    ChartSampleData(x: 'Jun', y: 38, y2: 40, y3: 24),
    ChartSampleData(x: 'Jul', y: 42, y2: 38, y3: 28),
    ChartSampleData(x: 'Aug', y: 45, y2: 42, y3: 32),
    ChartSampleData(x: 'Sep', y: 48, y2: 35, y3: 26),
    ChartSampleData(x: 'Oct', y: 43, y2: 44, y3: 34),
    ChartSampleData(x: 'Nov', y: 50, y2: 48, y3: 30),
    ChartSampleData(x: 'Dec', y: 55, y2: 50, y3: 36),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Line Chart',
      currentRoute: RouteNames.lineChart,
      body: ChartWrapper(
        title: 'Monthly Revenue by Product',
        subtitle: 'Multi-series line chart with interactive controls',
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
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            labelFormat: '\${value}K',
            minimum: 0,
            maximum: 60,
            interval: 10,
          ),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<ChartSampleData, String>>[
            LineSeries<ChartSampleData, String>(
              name: 'Electronics',
              dataSource: _revenueData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y,
              color: AppColors.chartPalette[0],
              width: 2.5,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 6, width: 6),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            LineSeries<ChartSampleData, String>(
              name: 'Clothing',
              dataSource: _revenueData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y2,
              color: AppColors.chartPalette[1],
              width: 2.5,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 6, width: 6),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            LineSeries<ChartSampleData, String>(
              name: 'Groceries',
              dataSource: _revenueData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y3,
              color: AppColors.chartPalette[2],
              width: 2.5,
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
