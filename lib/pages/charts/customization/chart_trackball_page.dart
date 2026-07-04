import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartTrackballPage extends StatefulWidget {
  const ChartTrackballPage({super.key});

  @override
  State<ChartTrackballPage> createState() => _ChartTrackballPageState();
}

class _ChartTrackballPageState extends State<ChartTrackballPage> {
  TrackballDisplayMode _displayMode = TrackballDisplayMode.floatAllPoints;
  TrackballLineType _lineType = TrackballLineType.vertical;
  ActivationMode _activationMode = ActivationMode.singleTap;

  final List<_TempData> _data = [
    _TempData('Jan', 5, -2, 12),
    _TempData('Feb', 7, 0, 14),
    _TempData('Mar', 12, 4, 18),
    _TempData('Apr', 18, 8, 22),
    _TempData('May', 24, 14, 28),
    _TempData('Jun', 30, 20, 34),
    _TempData('Jul', 33, 22, 36),
    _TempData('Aug', 32, 21, 35),
    _TempData('Sep', 28, 17, 30),
    _TempData('Oct', 20, 10, 24),
    _TempData('Nov', 12, 4, 18),
    _TempData('Dec', 6, -1, 13),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Chart Trackball',
      currentRoute: RouteNames.chartTrackball,
      body: ChartWrapper(
        title: 'Trackball Behavior',
        subtitle: 'Display modes, line type, activation mode',
        configPanel: ChartConfigPanel(children: [
          ConfigDropdown<TrackballDisplayMode>(
            label: 'Display Mode',
            value: _displayMode,
            items: TrackballDisplayMode.values,
            onChanged: (v) => setState(() => _displayMode = v),
            labelBuilder: (v) => v.name,
          ),
          ConfigDropdown<TrackballLineType>(
            label: 'Line Type',
            value: _lineType,
            items: TrackballLineType.values,
            onChanged: (v) => setState(() => _lineType = v),
            labelBuilder: (v) => v.name,
          ),
          ConfigDropdown<ActivationMode>(
            label: 'Activation',
            value: _activationMode,
            items: ActivationMode.values,
            onChanged: (v) => setState(() => _activationMode = v),
            labelBuilder: (v) => v.name,
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            labelFormat: '{value}°C',
            minimum: -10,
            maximum: 40,
            interval: 10,
          ),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          trackballBehavior: TrackballBehavior(
            enable: true,
            tooltipDisplayMode: _displayMode,
            lineType: _lineType,
            activationMode: _activationMode,
            tooltipSettings: const InteractiveTooltip(
              format: 'point.x : point.y°C',
            ),
          ),
          series: <CartesianSeries<_TempData, String>>[
            SplineSeries<_TempData, String>(
              name: 'Berlin',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.berlin,
              color: const Color(0xFF1565C0),
              width: 2.5,
            ),
            SplineSeries<_TempData, String>(
              name: 'Moscow',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.moscow,
              color: const Color(0xFF8E24AA),
              width: 2.5,
            ),
            SplineSeries<_TempData, String>(
              name: 'Madrid',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.madrid,
              color: const Color(0xFFD81B60),
              width: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}

class _TempData {
  final String month;
  final double berlin;
  final double moscow;
  final double madrid;

  _TempData(this.month, this.berlin, this.moscow, this.madrid);
}
