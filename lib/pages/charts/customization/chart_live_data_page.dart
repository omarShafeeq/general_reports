import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartLiveDataPage extends StatefulWidget {
  const ChartLiveDataPage({super.key});

  @override
  State<ChartLiveDataPage> createState() => _ChartLiveDataPageState();
}

class _ChartLiveDataPageState extends State<ChartLiveDataPage> {
  final List<_LivePoint> _data = [];
  Timer? _timer;
  bool _isRunning = false;
  int _tick = 0;
  final _random = Random();
  double _lastValue = 50;
  static const int _maxPoints = 60;

  @override
  void initState() {
    super.initState();
    _seedData();
  }

  void _seedData() {
    _data.clear();
    _tick = 0;
    _lastValue = 50;
    for (var i = 0; i < 20; i++) {
      _addPoint();
    }
  }

  void _addPoint() {
    _lastValue += (_random.nextDouble() - 0.48) * 6;
    _lastValue = _lastValue.clamp(10.0, 100.0);
    _data.add(_LivePoint(_tick, _lastValue));
    _tick++;
    if (_data.length > _maxPoints) {
      _data.removeAt(0);
    }
  }

  void _start() {
    if (_isRunning) return;
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _addPoint());
    });
    setState(() => _isRunning = true);
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _stop();
    setState(() => _seedData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ResponsiveScaffold(
      title: 'Live Data Chart',
      currentRoute: RouteNames.chartLiveData,
      body: ChartWrapper(
        title: 'Real-Time Streaming',
        subtitle: 'Timer-based live updating line chart',
        actions: [
          IconButton(
            icon: Icon(
              _isRunning ? Icons.pause_circle : Icons.play_circle,
              color: theme.colorScheme.primary,
            ),
            tooltip: _isRunning ? 'Pause' : 'Start',
            onPressed: _isRunning ? _stop : _start,
          ),
          IconButton(
            icon: Icon(Icons.restart_alt, color: theme.colorScheme.error),
            tooltip: 'Reset',
            onPressed: _reset,
          ),
        ],
        chart: SfCartesianChart(
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Time (ticks)'),
            majorGridLines: MajorGridLines(width: 0.5),
          ),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            maximum: 110,
            interval: 20,
            title: AxisTitle(text: 'Value'),
          ),
          series: <CartesianSeries<_LivePoint, int>>[
            FastLineSeries<_LivePoint, int>(
              dataSource: _data,
              xValueMapper: (d, _) => d.tick,
              yValueMapper: (d, _) => d.value,
              color: const Color(0xFF1565C0),
              width: 2,
              animationDuration: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _LivePoint {
  final int tick;
  final double value;
  const _LivePoint(this.tick, this.value);
}
