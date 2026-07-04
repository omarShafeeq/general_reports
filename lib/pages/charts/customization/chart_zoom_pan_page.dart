import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartZoomPanPage extends StatefulWidget {
  const ChartZoomPanPage({super.key});

  @override
  State<ChartZoomPanPage> createState() => _ChartZoomPanPageState();
}

class _ChartZoomPanPageState extends State<ChartZoomPanPage> {
  bool _enablePinchZooming = true;
  bool _enableSelectionZooming = true;
  bool _enablePanning = true;
  ZoomMode _zoomMode = ZoomMode.xy;

  final List<_StockData> _data = List.generate(
    80,
    (i) => _StockData(
      i,
      50 + 20 * _sin(i * 0.3) + 10 * _sin(i * 0.7),
    ),
  );

  static double _sin(double x) {
    const pi = 3.14159265;
    final n = x % (2 * pi);
    double result = n;
    final n3 = n * n * n;
    result -= n3 / 6;
    result += n3 * n * n / 120;
    return result.clamp(-1.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Zoom & Pan',
      currentRoute: RouteNames.chartZoomPan,
      body: ChartWrapper(
        title: 'Zoom & Pan Behavior',
        subtitle: 'Pinch zoom, selection zoom, panning, zoom mode',
        configPanel: ChartConfigPanel(children: [
          ConfigSwitch(
            label: 'Pinch Zoom',
            value: _enablePinchZooming,
            onChanged: (v) => setState(() => _enablePinchZooming = v),
          ),
          ConfigSwitch(
            label: 'Selection Zoom',
            value: _enableSelectionZooming,
            onChanged: (v) => setState(() => _enableSelectionZooming = v),
          ),
          ConfigSwitch(
            label: 'Panning',
            value: _enablePanning,
            onChanged: (v) => setState(() => _enablePanning = v),
          ),
          ConfigDropdown<ZoomMode>(
            label: 'Zoom Mode',
            value: _zoomMode,
            items: ZoomMode.values,
            onChanged: (v) => setState(() => _zoomMode = v),
            labelBuilder: (v) => v.name,
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const NumericAxis(),
          primaryYAxis: const NumericAxis(),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: _enablePinchZooming,
            enableSelectionZooming: _enableSelectionZooming,
            enablePanning: _enablePanning,
            zoomMode: _zoomMode,
            enableMouseWheelZooming: true,
          ),
          series: <CartesianSeries<_StockData, int>>[
            AreaSeries<_StockData, int>(
              dataSource: _data,
              xValueMapper: (d, _) => d.index,
              yValueMapper: (d, _) => d.value,
              color: const Color(0xFF1565C0).withOpacity(0.4),
              borderColor: const Color(0xFF1565C0),
              borderWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _StockData {
  final int index;
  final double value;

  const _StockData(this.index, this.value);
}
