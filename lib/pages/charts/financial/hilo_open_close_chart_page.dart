import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _HiloOcData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  const _HiloOcData(this.date, this.open, this.high, this.low, this.close);
}

class HiloOpenCloseChartPage extends StatefulWidget {
  const HiloOpenCloseChartPage({super.key});

  @override
  State<HiloOpenCloseChartPage> createState() => _HiloOpenCloseChartPageState();
}

class _HiloOpenCloseChartPageState extends State<HiloOpenCloseChartPage> {
  bool _useAlternateColors = false;
  bool _enableTooltip = true;

  late final List<_HiloOcData> _data;

  Color get _bullColor => _useAlternateColors
      ? const Color(0xFF00897B)
      : const Color(0xFF1E88E5);

  Color get _bearColor => _useAlternateColors
      ? const Color(0xFFE53935)
      : const Color(0xFFFF8F00);

  @override
  void initState() {
    super.initState();
    _data = _generateData();
  }

  static List<_HiloOcData> _generateData() {
    final rng = Random(77);
    final result = <_HiloOcData>[];
    double price = 220.0;
    final start = DateTime(2025, 2, 3);

    for (int i = 0; i < 50; i++) {
      final date = start.add(Duration(days: i));
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) continue;

      final change = (rng.nextDouble() - 0.48) * 5;
      final open = price;
      final close = price + change;
      final high = max(open, close) + rng.nextDouble() * 2.5;
      final low = min(open, close) - rng.nextDouble() * 2.5;

      result.add(_HiloOcData(date, open, high, low, close));
      price = close;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Hilo Open Close Chart',
      currentRoute: RouteNames.hiloOpenCloseChart,
      body: ChartWrapper(
        title: 'OHLC Price Action',
        subtitle: 'Open-High-Low-Close with bull/bear coloring',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Alternate Colors',
              value: _useAlternateColors,
              onChanged: (v) => setState(() => _useAlternateColors = v),
            ),
            ConfigSwitch(
              label: 'Tooltip',
              value: _enableTooltip,
              onChanged: (v) => setState(() => _enableTooltip = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: const NumericAxis(
            labelFormat: '\${value}',
          ),
          tooltipBehavior: TooltipBehavior(enable: _enableTooltip),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enablePanning: true,
            zoomMode: ZoomMode.x,
          ),
          series: <CartesianSeries<_HiloOcData, DateTime>>[
            HiloOpenCloseSeries<_HiloOcData, DateTime>(
              dataSource: _data,
              xValueMapper: (d, _) => d.date,
              openValueMapper: (d, _) => d.open,
              highValueMapper: (d, _) => d.high,
              lowValueMapper: (d, _) => d.low,
              closeValueMapper: (d, _) => d.close,
              bullColor: _bullColor,
              bearColor: _bearColor,
            ),
          ],
        ),
      ),
    );
  }
}
