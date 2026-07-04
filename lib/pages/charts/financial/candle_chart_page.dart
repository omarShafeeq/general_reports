import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _OhlcData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  const _OhlcData(this.date, this.open, this.high, this.low, this.close, this.volume);
}

class CandleChartPage extends StatefulWidget {
  const CandleChartPage({super.key});

  @override
  State<CandleChartPage> createState() => _CandleChartPageState();
}

class _CandleChartPageState extends State<CandleChartPage> {
  bool _showVolume = true;
  bool _useAlternateColors = false;

  late final List<_OhlcData> _data;

  Color get _bullColor => _useAlternateColors
      ? const Color(0xFF1E88E5)
      : const Color(0xFF26A69A);

  Color get _bearColor => _useAlternateColors
      ? const Color(0xFFFF8F00)
      : const Color(0xFFEF5350);

  @override
  void initState() {
    super.initState();
    _data = _generateOhlcData();
  }

  static List<_OhlcData> _generateOhlcData() {
    final rng = Random(42);
    final result = <_OhlcData>[];
    double price = 150.0;
    final start = DateTime(2025, 1, 2);

    for (int i = 0; i < 60; i++) {
      final date = start.add(Duration(days: i));
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) continue;

      final change = (rng.nextDouble() - 0.48) * 6;
      final open = price;
      final close = price + change;
      final high = max(open, close) + rng.nextDouble() * 3;
      final low = min(open, close) - rng.nextDouble() * 3;
      final volume = 500000 + rng.nextInt(1500000).toDouble();

      result.add(_OhlcData(date, open, high, low, close, volume));
      price = close;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Candlestick Chart',
      currentRoute: RouteNames.candleChart,
      body: ChartWrapper(
        title: 'IX Corp Stock Price',
        subtitle: '60-day OHLC with volume overlay',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Show Volume',
              value: _showVolume,
              onChanged: (v) => setState(() => _showVolume = v),
            ),
            ConfigSwitch(
              label: 'Alternate Colors',
              value: _useAlternateColors,
              onChanged: (v) => setState(() => _useAlternateColors = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
            dateFormat: DateFormat.MMMd('en_US'),
          ),
          primaryYAxis: const NumericAxis(
            opposedPosition: true,
            labelFormat: '\${value}',
          ),
          axes: _showVolume
              ? <ChartAxis>[
                  NumericAxis(
                    name: 'volumeAxis',
                    opposedPosition: false,
                    maximum: _data.fold<double>(
                            0, (prev, d) => max(prev, d.volume)) *
                        4,
                    isVisible: false,
                  ),
                ]
              : const <ChartAxis>[],
          crosshairBehavior: CrosshairBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enablePanning: true,
            zoomMode: ZoomMode.x,
          ),
          series: <CartesianSeries<_OhlcData, DateTime>>[
            if (_showVolume)
              ColumnSeries<_OhlcData, DateTime>(
                dataSource: _data,
                xValueMapper: (d, _) => d.date,
                yValueMapper: (d, _) => d.volume,
                yAxisName: 'volumeAxis',
                color: Colors.grey.withAlpha(40),
                borderWidth: 0,
                width: 0.7,
                animationDuration: 0,
              ),
            CandleSeries<_OhlcData, DateTime>(
              dataSource: _data,
              xValueMapper: (d, _) => d.date,
              openValueMapper: (d, _) => d.open,
              highValueMapper: (d, _) => d.high,
              lowValueMapper: (d, _) => d.low,
              closeValueMapper: (d, _) => d.close,
              bullColor: _bullColor,
              bearColor: _bearColor,
              enableSolidCandles: true,
            ),
          ],
        ),
      ),
    );
  }
}
