import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/core/constants/app_colors.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class _FastLinePoint {
  final int x;
  final double y;
  const _FastLinePoint(this.x, this.y);
}

class FastLineChartPage extends StatefulWidget {
  const FastLineChartPage({super.key});

  @override
  State<FastLineChartPage> createState() => _FastLineChartPageState();
}

class _FastLineChartPageState extends State<FastLineChartPage> {
  bool _enableTooltip = true;
  bool _animate = true;
  int _pointCount = 1000;
  late List<_FastLinePoint> _data;

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    final rng = Random(42);
    double value = 50;
    _data = List.generate(_pointCount, (i) {
      value += (rng.nextDouble() - 0.5) * 6;
      value = value.clamp(0, 100);
      return _FastLinePoint(i, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Fast Line Chart',
      currentRoute: RouteNames.fastLineChart,
      body: ChartWrapper(
        title: 'High-Performance Rendering',
        subtitle: 'Rendering $_pointCount data points with FastLineSeries',
        configPanel: ChartConfigPanel(children: [
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
          ConfigDropdown<int>(
            label: 'Points',
            value: _pointCount,
            items: const [500, 1000, 5000, 10000],
            onChanged: (v) => setState(() {
              _pointCount = v;
              _generateData();
            }),
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Index')),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Value'),
            minimum: 0,
            maximum: 100,
          ),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          series: <CartesianSeries<_FastLinePoint, int>>[
            FastLineSeries<_FastLinePoint, int>(
              dataSource: _data,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              color: AppColors.chartPalette[0],
              animationDuration: _animate ? 1500 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
