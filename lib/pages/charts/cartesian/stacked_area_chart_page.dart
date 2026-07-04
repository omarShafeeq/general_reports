import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/models/chart_sample_data.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class StackedAreaChartPage extends StatefulWidget {
  const StackedAreaChartPage({super.key});

  @override
  State<StackedAreaChartPage> createState() => _StackedAreaChartPageState();
}

class _StackedAreaChartPageState extends State<StackedAreaChartPage> {
  bool _showMarkers = false;
  bool _showDataLabels = false;
  bool _enableTooltip = true;
  bool _animate = true;
  bool _grouped = false;

  final List<ChartSampleData> _channelData = const [
    ChartSampleData(x: 'Q1 \'23', y: 40, y2: 25, y3: 18, y4: 12),
    ChartSampleData(x: 'Q2 \'23', y: 44, y2: 28, y3: 20, y4: 14),
    ChartSampleData(x: 'Q3 \'23', y: 48, y2: 30, y3: 22, y4: 16),
    ChartSampleData(x: 'Q4 \'23', y: 52, y2: 32, y3: 24, y4: 18),
    ChartSampleData(x: 'Q1 \'24', y: 55, y2: 35, y3: 26, y4: 20),
    ChartSampleData(x: 'Q2 \'24', y: 58, y2: 38, y3: 28, y4: 22),
    ChartSampleData(x: 'Q3 \'24', y: 62, y2: 40, y3: 30, y4: 25),
    ChartSampleData(x: 'Q4 \'24', y: 68, y2: 42, y3: 32, y4: 28),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Stacked Area Chart',
      currentRoute: RouteNames.stackedAreaChart,
      body: ChartWrapper(
        title: 'Revenue by Sales Channel',
        subtitle: 'Stacked area showing cumulative channel contribution',
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
            label: 'Group Mode',
            value: _grouped,
            onChanged: (v) => setState(() => _grouped = v),
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
          ),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<ChartSampleData, String>>[
            StackedAreaSeries<ChartSampleData, String>(
              name: 'Direct',
              dataSource: _channelData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y,
              groupName: _grouped ? 'Group A' : '',
              color: AppColors.chartPalette[0].withOpacity(0.7),
              borderColor: AppColors.chartPalette[0],
              borderWidth: 1.5,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 5, width: 5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            StackedAreaSeries<ChartSampleData, String>(
              name: 'Retail',
              dataSource: _channelData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y2,
              groupName: _grouped ? 'Group A' : '',
              color: AppColors.chartPalette[1].withOpacity(0.7),
              borderColor: AppColors.chartPalette[1],
              borderWidth: 1.5,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 5, width: 5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            StackedAreaSeries<ChartSampleData, String>(
              name: 'Partner',
              dataSource: _channelData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y3,
              groupName: _grouped ? 'Group B' : '',
              color: AppColors.chartPalette[2].withOpacity(0.7),
              borderColor: AppColors.chartPalette[2],
              borderWidth: 1.5,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 5, width: 5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            StackedAreaSeries<ChartSampleData, String>(
              name: 'Marketplace',
              dataSource: _channelData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y4,
              groupName: _grouped ? 'Group B' : '',
              color: AppColors.chartPalette[3].withOpacity(0.7),
              borderColor: AppColors.chartPalette[3],
              borderWidth: 1.5,
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
