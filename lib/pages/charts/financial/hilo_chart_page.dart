import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _HiloData {
  final DateTime date;
  final double high;
  final double low;
  const _HiloData(this.date, this.high, this.low);
}

class HiloChartPage extends StatefulWidget {
  const HiloChartPage({super.key});

  @override
  State<HiloChartPage> createState() => _HiloChartPageState();
}

class _HiloChartPageState extends State<HiloChartPage> {
  bool _showDataLabels = false;
  bool _enableTooltip = true;

  late final List<_HiloData> _data;

  @override
  void initState() {
    super.initState();
    _data = _generateData();
  }

  static List<_HiloData> _generateData() {
    final rng = Random(99);
    final result = <_HiloData>[];
    double base = 85.0;
    final start = DateTime(2025, 3, 3);

    for (int i = 0; i < 40; i++) {
      final date = start.add(Duration(days: i));
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) continue;

      base += (rng.nextDouble() - 0.47) * 3;
      final high = base + rng.nextDouble() * 4 + 1;
      final low = base - rng.nextDouble() * 4 - 1;
      result.add(_HiloData(date, high, low));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Hilo Chart',
      currentRoute: RouteNames.hiloChart,
      body: ChartWrapper(
        title: 'Daily Price Range',
        subtitle: 'High-Low price bands for sample equity',
        configPanel: ChartConfigPanel(
          children: [
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
          series: <CartesianSeries<_HiloData, DateTime>>[
            HiloSeries<_HiloData, DateTime>(
              dataSource: _data,
              xValueMapper: (d, _) => d.date,
              highValueMapper: (d, _) => d.high,
              lowValueMapper: (d, _) => d.low,
              color: const Color(0xFF5C6BC0),
              dataLabelSettings: DataLabelSettings(
                isVisible: _showDataLabels,
                textStyle: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
