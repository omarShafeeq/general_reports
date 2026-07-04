import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/models/chart_sample_data.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class RangeAreaChartPage extends StatefulWidget {
  const RangeAreaChartPage({super.key});

  @override
  State<RangeAreaChartPage> createState() => _RangeAreaChartPageState();
}

class _RangeAreaChartPageState extends State<RangeAreaChartPage> {
  bool _showMarkers = false;
  bool _showDataLabels = false;
  bool _enableTooltip = true;
  bool _animate = true;

  final List<ChartSampleData> _temperatureRange = const [
    ChartSampleData(x: 'Jan', y: -2, y2: 6),
    ChartSampleData(x: 'Feb', y: -1, y2: 8),
    ChartSampleData(x: 'Mar', y: 2, y2: 12),
    ChartSampleData(x: 'Apr', y: 6, y2: 17),
    ChartSampleData(x: 'May', y: 10, y2: 22),
    ChartSampleData(x: 'Jun', y: 14, y2: 26),
    ChartSampleData(x: 'Jul', y: 16, y2: 29),
    ChartSampleData(x: 'Aug', y: 15, y2: 28),
    ChartSampleData(x: 'Sep', y: 12, y2: 23),
    ChartSampleData(x: 'Oct', y: 7, y2: 16),
    ChartSampleData(x: 'Nov', y: 3, y2: 10),
    ChartSampleData(x: 'Dec', y: -1, y2: 7),
  ];

  final List<ChartSampleData> _temperatureRange2 = const [
    ChartSampleData(x: 'Jan', y: 3, y2: 10),
    ChartSampleData(x: 'Feb', y: 4, y2: 12),
    ChartSampleData(x: 'Mar', y: 7, y2: 16),
    ChartSampleData(x: 'Apr', y: 10, y2: 20),
    ChartSampleData(x: 'May', y: 14, y2: 25),
    ChartSampleData(x: 'Jun', y: 18, y2: 30),
    ChartSampleData(x: 'Jul', y: 20, y2: 33),
    ChartSampleData(x: 'Aug', y: 19, y2: 32),
    ChartSampleData(x: 'Sep', y: 16, y2: 27),
    ChartSampleData(x: 'Oct', y: 12, y2: 20),
    ChartSampleData(x: 'Nov', y: 7, y2: 14),
    ChartSampleData(x: 'Dec', y: 4, y2: 11),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Range Area Chart',
      currentRoute: RouteNames.rangeAreaChart,
      body: ChartWrapper(
        title: 'Monthly Temperature Range',
        subtitle: 'High/Low temperature bands for Berlin and Madrid',
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
            labelFormat: '{value}°C',
            minimum: -5,
            maximum: 40,
            interval: 5,
          ),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<ChartSampleData, String>>[
            RangeAreaSeries<ChartSampleData, String>(
              name: 'Berlin',
              dataSource: _temperatureRange,
              xValueMapper: (d, _) => d.x as String,
              lowValueMapper: (d, _) => d.y,
              highValueMapper: (d, _) => d.y2,
              color: AppColors.chartPalette[0].withOpacity(0.35),
              borderColor: AppColors.chartPalette[0],
              borderWidth: 2,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 5, width: 5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            RangeAreaSeries<ChartSampleData, String>(
              name: 'Madrid',
              dataSource: _temperatureRange2,
              xValueMapper: (d, _) => d.x as String,
              lowValueMapper: (d, _) => d.y,
              highValueMapper: (d, _) => d.y2,
              color: AppColors.chartPalette[2].withOpacity(0.35),
              borderColor: AppColors.chartPalette[2],
              borderWidth: 2,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 5, width: 5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
