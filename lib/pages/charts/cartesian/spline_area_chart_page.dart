import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/models/chart_sample_data.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class SplineAreaChartPage extends StatefulWidget {
  const SplineAreaChartPage({super.key});

  @override
  State<SplineAreaChartPage> createState() => _SplineAreaChartPageState();
}

class _SplineAreaChartPageState extends State<SplineAreaChartPage> {
  bool _showMarkers = false;
  bool _showDataLabels = false;
  bool _enableTooltip = true;
  bool _animate = true;
  bool _showGradient = true;

  final List<ChartSampleData> _salesData = const [
    ChartSampleData(x: 'Jan', y: 12, y2: 8),
    ChartSampleData(x: 'Feb', y: 15, y2: 10),
    ChartSampleData(x: 'Mar', y: 20, y2: 14),
    ChartSampleData(x: 'Apr', y: 18, y2: 16),
    ChartSampleData(x: 'May', y: 25, y2: 19),
    ChartSampleData(x: 'Jun', y: 30, y2: 22),
    ChartSampleData(x: 'Jul', y: 28, y2: 25),
    ChartSampleData(x: 'Aug', y: 35, y2: 28),
    ChartSampleData(x: 'Sep', y: 32, y2: 24),
    ChartSampleData(x: 'Oct', y: 38, y2: 30),
    ChartSampleData(x: 'Nov', y: 42, y2: 34),
    ChartSampleData(x: 'Dec', y: 48, y2: 38),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Spline Area Chart',
      currentRoute: RouteNames.splineAreaChart,
      body: ChartWrapper(
        title: 'Sales Growth with Gradient Fill',
        subtitle: 'Spline area chart with optional gradient shading',
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
            label: 'Gradient',
            value: _showGradient,
            onChanged: (v) => setState(() => _showGradient = v),
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
            maximum: 55,
            interval: 10,
          ),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<ChartSampleData, String>>[
            SplineAreaSeries<ChartSampleData, String>(
              name: 'Online Sales',
              dataSource: _salesData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y,
              color: AppColors.chartPalette[0].withOpacity(0.7),
              borderColor: AppColors.chartPalette[0],
              borderWidth: 2,
              gradient: _showGradient
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.chartPalette[0].withOpacity(0.6),
                        AppColors.chartPalette[0].withOpacity(0.05),
                      ],
                    )
                  : null,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 5, width: 5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            SplineAreaSeries<ChartSampleData, String>(
              name: 'In-Store Sales',
              dataSource: _salesData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y2,
              color: AppColors.chartPalette[1].withOpacity(0.7),
              borderColor: AppColors.chartPalette[1],
              borderWidth: 2,
              gradient: _showGradient
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.chartPalette[1].withOpacity(0.6),
                        AppColors.chartPalette[1].withOpacity(0.05),
                      ],
                    )
                  : null,
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
