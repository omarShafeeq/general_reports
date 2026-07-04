import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartAnimationPage extends StatefulWidget {
  const ChartAnimationPage({super.key});

  @override
  State<ChartAnimationPage> createState() => _ChartAnimationPageState();
}

class _ChartAnimationPageState extends State<ChartAnimationPage> {
  double _duration = 1500;
  double _delay = 0;
  Key _chartKey = UniqueKey();

  final List<_GrowthData> _data = const [
    _GrowthData('2018', 22, 18),
    _GrowthData('2019', 30, 24),
    _GrowthData('2020', 25, 28),
    _GrowthData('2021', 38, 32),
    _GrowthData('2022', 42, 36),
    _GrowthData('2023', 48, 40),
    _GrowthData('2024', 55, 46),
  ];

  void _replay() {
    setState(() => _chartKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Chart Animation',
      currentRoute: RouteNames.chartAnimation,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _replay,
        icon: const Icon(Icons.replay),
        label: const Text('Replay'),
      ),
      body: ChartWrapper(
        title: 'Animation Duration & Delay',
        subtitle: 'Control animation timing per series',
        configPanel: ChartConfigPanel(children: [
          ConfigSlider(
            label: 'Duration (ms)',
            value: _duration,
            min: 0,
            max: 5000,
            divisions: 50,
            onChanged: (v) => setState(() => _duration = v),
          ),
          ConfigSlider(
            label: 'Delay (ms)',
            value: _delay,
            min: 0,
            max: 2000,
            divisions: 20,
            onChanged: (v) => setState(() => _delay = v),
          ),
        ]),
        chart: SfCartesianChart(
          key: _chartKey,
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            maximum: 60,
            interval: 10,
            labelFormat: '{value}%',
          ),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_GrowthData, String>>[
            ColumnSeries<_GrowthData, String>(
              name: 'Revenue Growth',
              dataSource: _data,
              xValueMapper: (d, _) => d.year,
              yValueMapper: (d, _) => d.revenue,
              color: const Color(0xFF1565C0),
              animationDuration: _duration,
              animationDelay: _delay,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            ColumnSeries<_GrowthData, String>(
              name: 'Profit Growth',
              dataSource: _data,
              xValueMapper: (d, _) => d.year,
              yValueMapper: (d, _) => d.profit,
              color: const Color(0xFF00897B),
              animationDuration: _duration,
              animationDelay: _delay + 300,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrowthData {
  final String year;
  final double revenue;
  final double profit;
  const _GrowthData(this.year, this.revenue, this.profit);
}
