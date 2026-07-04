import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _KpiData {
  final String label;
  final double value;
  final double target;
  final Color color;
  const _KpiData(this.label, this.value, this.target, this.color);
}

const _data = <_KpiData>[
  _KpiData('Revenue', 87, 100, Color(0xFF36B37E)),
  _KpiData('New Clients', 64, 100, Color(0xFF0065FF)),
  _KpiData('Retention', 92, 100, Color(0xFFFF5630)),
  _KpiData('Satisfaction', 78, 100, Color(0xFFFFAB00)),
  _KpiData('Deliveries', 95, 100, Color(0xFF6554C0)),
];

class RadialBarChartPage extends StatefulWidget {
  const RadialBarChartPage({super.key});

  @override
  State<RadialBarChartPage> createState() => _RadialBarChartPageState();
}

class _RadialBarChartPageState extends State<RadialBarChartPage> {
  double _innerRadius = 30;
  double _maxValue = 100;
  bool _showTrack = true;

  double get _avgProgress =>
      _data.fold(0.0, (sum, d) => sum + d.value) / _data.length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Radial Bar Chart',
      currentRoute: RouteNames.radialBarChart,
      body: ChartWrapper(
        title: 'KPI Progress Dashboard',
        subtitle: 'Q2 2025 goals achievement overview',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSlider(
              label: 'Inner Radius',
              value: _innerRadius,
              min: 10,
              max: 70,
              divisions: 12,
              onChanged: (v) => setState(() => _innerRadius = v),
            ),
            ConfigSlider(
              label: 'Max Value',
              value: _maxValue,
              min: 50,
              max: 150,
              divisions: 10,
              onChanged: (v) => setState(() => _maxValue = v),
            ),
            ConfigSwitch(
              label: 'Show Track',
              value: _showTrack,
              onChanged: (v) => setState(() => _showTrack = v),
            ),
          ],
        ),
        chart: SfCircularChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            format: 'point.x: point.y%',
          ),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_avgProgress.toStringAsFixed(0)}%',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Avg Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
          series: <CircularSeries<_KpiData, String>>[
            RadialBarSeries<_KpiData, String>(
              dataSource: _data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (d, _) => d.color,
              innerRadius: '${_innerRadius.round()}%',
              maximumValue: _maxValue,
              trackColor: _showTrack
                  ? theme.colorScheme.surfaceContainerHighest
                  : Colors.transparent,
              trackBorderWidth: 0,
              cornerStyle: CornerStyle.bothCurve,
              gap: '3%',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              dataLabelMapper: (d, _) => '${d.value.toStringAsFixed(0)}%',
              animationDuration: 1000,
            ),
          ],
        ),
      ),
    );
  }
}
