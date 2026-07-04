import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/models/chart_sample_data.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class StepAreaChartPage extends StatefulWidget {
  const StepAreaChartPage({super.key});

  @override
  State<StepAreaChartPage> createState() => _StepAreaChartPageState();
}

class _StepAreaChartPageState extends State<StepAreaChartPage> {
  bool _showMarkers = false;
  bool _showDataLabels = false;
  bool _enableTooltip = true;
  bool _animate = true;

  final List<ChartSampleData> _inventoryData = const [
    ChartSampleData(x: 'Week 1', y: 500, y2: 320),
    ChartSampleData(x: 'Week 2', y: 480, y2: 350),
    ChartSampleData(x: 'Week 3', y: 420, y2: 310),
    ChartSampleData(x: 'Week 4', y: 550, y2: 400),
    ChartSampleData(x: 'Week 5', y: 520, y2: 380),
    ChartSampleData(x: 'Week 6', y: 460, y2: 340),
    ChartSampleData(x: 'Week 7', y: 600, y2: 420),
    ChartSampleData(x: 'Week 8', y: 580, y2: 450),
    ChartSampleData(x: 'Week 9', y: 530, y2: 390),
    ChartSampleData(x: 'Week 10', y: 610, y2: 460),
    ChartSampleData(x: 'Week 11', y: 590, y2: 430),
    ChartSampleData(x: 'Week 12', y: 640, y2: 480),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Step Area Chart',
      currentRoute: RouteNames.stepAreaChart,
      body: ChartWrapper(
        title: 'Warehouse Inventory Levels',
        subtitle: 'Step area showing discrete inventory changes per week',
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
            title: AxisTitle(text: 'Units'),
            minimum: 200,
            maximum: 700,
            interval: 100,
          ),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<ChartSampleData, String>>[
            StepAreaSeries<ChartSampleData, String>(
              name: 'Warehouse A',
              dataSource: _inventoryData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y,
              color: AppColors.chartPalette[0].withOpacity(0.4),
              borderColor: AppColors.chartPalette[0],
              borderWidth: 2,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 5, width: 5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            StepAreaSeries<ChartSampleData, String>(
              name: 'Warehouse B',
              dataSource: _inventoryData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y2,
              color: AppColors.chartPalette[1].withOpacity(0.4),
              borderColor: AppColors.chartPalette[1],
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
