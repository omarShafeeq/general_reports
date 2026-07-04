import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartStylingPage extends StatefulWidget {
  const ChartStylingPage({super.key});

  @override
  State<ChartStylingPage> createState() => _ChartStylingPageState();
}

class _ChartStylingPageState extends State<ChartStylingPage> {
  bool _useGradient = true;
  bool _useDash = false;
  double _opacity = 1.0;
  double _borderWidth = 2.0;

  final List<_WaveData> _areaData = const [
    _WaveData('Jan', 12),
    _WaveData('Feb', 20),
    _WaveData('Mar', 16),
    _WaveData('Apr', 28),
    _WaveData('May', 24),
    _WaveData('Jun', 32),
    _WaveData('Jul', 30),
    _WaveData('Aug', 38),
    _WaveData('Sep', 34),
    _WaveData('Oct', 42),
    _WaveData('Nov', 40),
    _WaveData('Dec', 48),
  ];

  final List<_WaveData> _lineData = const [
    _WaveData('Jan', 8),
    _WaveData('Feb', 14),
    _WaveData('Mar', 22),
    _WaveData('Apr', 18),
    _WaveData('May', 30),
    _WaveData('Jun', 26),
    _WaveData('Jul', 36),
    _WaveData('Aug', 32),
    _WaveData('Sep', 40),
    _WaveData('Oct', 36),
    _WaveData('Nov', 44),
    _WaveData('Dec', 42),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [const Color(0xFF42A5F5), const Color(0xFF0D47A1)]
        : [const Color(0xFF1565C0), const Color(0xFF42A5F5)];

    return ResponsiveScaffold(
      title: 'Chart Styling',
      currentRoute: RouteNames.chartStyling,
      body: ChartWrapper(
        title: 'Gradient, Dash & Opacity',
        subtitle: 'Visual styling options for series',
        configPanel: ChartConfigPanel(children: [
          ConfigSwitch(
            label: 'Gradient Fill',
            value: _useGradient,
            onChanged: (v) => setState(() => _useGradient = v),
          ),
          ConfigSwitch(
            label: 'Dashed Line',
            value: _useDash,
            onChanged: (v) => setState(() => _useDash = v),
          ),
          ConfigSlider(
            label: 'Opacity',
            value: _opacity,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            onChanged: (v) => setState(() => _opacity = v),
          ),
          ConfigSlider(
            label: 'Border Width',
            value: _borderWidth,
            min: 0,
            max: 5,
            divisions: 10,
            onChanged: (v) => setState(() => _borderWidth = v),
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            maximum: 55,
            interval: 10,
          ),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_WaveData, String>>[
            AreaSeries<_WaveData, String>(
              name: 'Gradient Area',
              dataSource: _areaData,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.value,
              gradient: _useGradient
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors,
                    )
                  : null,
              color: _useGradient ? null : const Color(0xFF1565C0),
              opacity: _opacity,
              borderColor: const Color(0xFF0D47A1),
              borderWidth: _borderWidth,
            ),
            LineSeries<_WaveData, String>(
              name: 'Dashed Line',
              dataSource: _lineData,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.value,
              color: const Color(0xFFD81B60),
              width: _borderWidth,
              opacity: _opacity,
              dashArray: _useDash ? const <double>[8, 4] : null,
              markerSettings: const MarkerSettings(
                isVisible: true,
                height: 6,
                width: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveData {
  final String month;
  final double value;
  const _WaveData(this.month, this.value);
}
