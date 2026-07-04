import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartCrosshairPage extends StatefulWidget {
  const ChartCrosshairPage({super.key});

  @override
  State<ChartCrosshairPage> createState() => _ChartCrosshairPageState();
}

class _ChartCrosshairPageState extends State<ChartCrosshairPage> {
  CrosshairLineType _lineType = CrosshairLineType.both;
  bool _showXTooltip = true;
  bool _showYTooltip = true;
  double _dashLength = 0;

  final List<_PriceData> _data = List.generate(
    50,
    (i) => _PriceData(i.toDouble(), 100 + 30 * _wave(i)),
  );

  static double _wave(int i) {
    const pi = 3.14159265;
    return (i * pi / 12).remainder(2 * pi) < pi
        ? (i % 7) * 0.15
        : -(i % 5) * 0.12;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Chart Crosshair',
      currentRoute: RouteNames.chartCrosshair,
      body: ChartWrapper(
        title: 'Crosshair Behavior',
        subtitle: 'Line type, dash array, axis tooltips',
        configPanel: ChartConfigPanel(children: [
          ConfigDropdown<CrosshairLineType>(
            label: 'Line Type',
            value: _lineType,
            items: CrosshairLineType.values,
            onChanged: (v) => setState(() => _lineType = v),
            labelBuilder: (v) => v.name,
          ),
          ConfigSwitch(
            label: 'X Tooltip',
            value: _showXTooltip,
            onChanged: (v) => setState(() => _showXTooltip = v),
          ),
          ConfigSwitch(
            label: 'Y Tooltip',
            value: _showYTooltip,
            onChanged: (v) => setState(() => _showYTooltip = v),
          ),
          ConfigSlider(
            label: 'Dash',
            value: _dashLength,
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (v) => setState(() => _dashLength = v),
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: NumericAxis(
            crossesAt: 0,
            interactiveTooltip: InteractiveTooltip(enable: _showXTooltip),
          ),
          primaryYAxis: NumericAxis(
            interactiveTooltip: InteractiveTooltip(enable: _showYTooltip),
          ),
          crosshairBehavior: CrosshairBehavior(
            enable: true,
            lineType: _lineType,
            lineDashArray: _dashLength > 0 ? [_dashLength, _dashLength] : null,
            activationMode: ActivationMode.singleTap,
          ),
          series: <CartesianSeries<_PriceData, double>>[
            LineSeries<_PriceData, double>(
              dataSource: _data,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              color: const Color(0xFF5C6BC0),
              width: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceData {
  final double x;
  final double y;

  const _PriceData(this.x, this.y);
}
