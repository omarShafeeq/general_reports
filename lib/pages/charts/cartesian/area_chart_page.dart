import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/models/chart_sample_data.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class AreaChartPage extends StatefulWidget {
  const AreaChartPage({super.key});

  @override
  State<AreaChartPage> createState() => _AreaChartPageState();
}

class _AreaChartPageState extends State<AreaChartPage> {
  bool _showMarkers = false;
  bool _showDataLabels = false;
  bool _enableTooltip = true;
  bool _animate = true;
  bool _showGradient = true;
  double _opacity = 0.5;

  final List<ChartSampleData> _trafficData = const [
    ChartSampleData(x: 'Mon', y: 1200, y2: 900),
    ChartSampleData(x: 'Tue', y: 1450, y2: 1100),
    ChartSampleData(x: 'Wed', y: 1380, y2: 1050),
    ChartSampleData(x: 'Thu', y: 1520, y2: 1200),
    ChartSampleData(x: 'Fri', y: 1680, y2: 1350),
    ChartSampleData(x: 'Sat', y: 2100, y2: 1600),
    ChartSampleData(x: 'Sun', y: 1950, y2: 1500),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Area Chart',
      currentRoute: RouteNames.areaChart,
      body: ChartWrapper(
        title: 'Weekly Website Traffic',
        subtitle: 'Area chart with configurable opacity and gradient',
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
          ConfigSlider(
            label: 'Opacity',
            value: _opacity,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            onChanged: (v) => setState(() => _opacity = v),
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Visitors'),
            minimum: 0,
            maximum: 2500,
            interval: 500,
          ),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<ChartSampleData, String>>[
            AreaSeries<ChartSampleData, String>(
              name: 'Desktop',
              dataSource: _trafficData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y,
              opacity: _showGradient ? 1.0 : _opacity,
              borderColor: AppColors.chartPalette[0],
              borderWidth: 2,
              color: AppColors.chartPalette[0].withOpacity(_opacity),
              gradient: _showGradient
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.chartPalette[0].withOpacity(_opacity),
                        AppColors.chartPalette[0].withOpacity(0.05),
                      ],
                    )
                  : null,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 5, width: 5),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            AreaSeries<ChartSampleData, String>(
              name: 'Mobile',
              dataSource: _trafficData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y2,
              opacity: _showGradient ? 1.0 : _opacity,
              borderColor: AppColors.chartPalette[2],
              borderWidth: 2,
              color: AppColors.chartPalette[2].withOpacity(_opacity),
              gradient: _showGradient
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.chartPalette[2].withOpacity(_opacity),
                        AppColors.chartPalette[2].withOpacity(0.05),
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
