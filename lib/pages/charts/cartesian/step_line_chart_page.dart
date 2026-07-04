import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/models/chart_sample_data.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class StepLineChartPage extends StatefulWidget {
  const StepLineChartPage({super.key});

  @override
  State<StepLineChartPage> createState() => _StepLineChartPageState();
}

class _StepLineChartPageState extends State<StepLineChartPage> {
  bool _showMarkers = true;
  bool _showDataLabels = false;
  bool _enableTooltip = true;
  bool _animate = true;
  bool _showDashArray = true;

  final List<ChartSampleData> _pricingData = const [
    ChartSampleData(x: 'Jan', y: 9.99, y2: 14.99),
    ChartSampleData(x: 'Feb', y: 9.99, y2: 14.99),
    ChartSampleData(x: 'Mar', y: 12.99, y2: 14.99),
    ChartSampleData(x: 'Apr', y: 12.99, y2: 19.99),
    ChartSampleData(x: 'May', y: 12.99, y2: 19.99),
    ChartSampleData(x: 'Jun', y: 15.99, y2: 19.99),
    ChartSampleData(x: 'Jul', y: 15.99, y2: 24.99),
    ChartSampleData(x: 'Aug', y: 15.99, y2: 24.99),
    ChartSampleData(x: 'Sep', y: 18.99, y2: 24.99),
    ChartSampleData(x: 'Oct', y: 18.99, y2: 29.99),
    ChartSampleData(x: 'Nov', y: 18.99, y2: 29.99),
    ChartSampleData(x: 'Dec', y: 21.99, y2: 29.99),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Step Line Chart',
      currentRoute: RouteNames.stepLineChart,
      body: ChartWrapper(
        title: 'Subscription Pricing Tiers',
        subtitle: 'Step transitions showing discrete price changes',
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
            label: 'Dash Array',
            value: _showDashArray,
            onChanged: (v) => setState(() => _showDashArray = v),
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
            labelFormat: '\${value}',
            minimum: 5,
            maximum: 35,
            interval: 5,
          ),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<ChartSampleData, String>>[
            StepLineSeries<ChartSampleData, String>(
              name: 'Basic Plan',
              dataSource: _pricingData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y,
              color: AppColors.chartPalette[0],
              width: 2.5,
              dashArray: _showDashArray ? const <double>[5, 3] : null,
              markerSettings: MarkerSettings(isVisible: _showMarkers, height: 6, width: 6),
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
              animationDuration: _animate ? 1500 : 0,
            ),
            StepLineSeries<ChartSampleData, String>(
              name: 'Pro Plan',
              dataSource: _pricingData,
              xValueMapper: (d, _) => d.x as String,
              yValueMapper: (d, _) => d.y2,
              color: AppColors.chartPalette[3],
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
