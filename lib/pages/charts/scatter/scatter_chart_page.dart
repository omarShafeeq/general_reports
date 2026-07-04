import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _ScatterPoint {
  final double x;
  final double y;
  _ScatterPoint(this.x, this.y);
}

class ScatterChartPage extends StatefulWidget {
  const ScatterChartPage({super.key});

  @override
  State<ScatterChartPage> createState() => _ScatterChartPageState();
}

class _ScatterChartPageState extends State<ScatterChartPage> {
  DataMarkerType _markerShape = DataMarkerType.circle;
  double _markerSize = 10;
  double _opacity = 0.85;

  static const _shapeLabels = <DataMarkerType, String>{
    DataMarkerType.circle: 'Circle',
    DataMarkerType.diamond: 'Diamond',
    DataMarkerType.triangle: 'Triangle',
    DataMarkerType.pentagon: 'Pentagon',
    DataMarkerType.rectangle: 'Rectangle',
  };

  late final List<_ScatterPoint> _seriesA;
  late final List<_ScatterPoint> _seriesB;

  @override
  void initState() {
    super.initState();
    _seriesA = [
      _ScatterPoint(1, 28), _ScatterPoint(2, 44), _ScatterPoint(3, 35),
      _ScatterPoint(4, 50), _ScatterPoint(5, 54), _ScatterPoint(6, 21),
      _ScatterPoint(7, 63), _ScatterPoint(8, 45), _ScatterPoint(9, 72),
      _ScatterPoint(10, 38), _ScatterPoint(11, 55), _ScatterPoint(12, 60),
    ];
    _seriesB = [
      _ScatterPoint(1, 17), _ScatterPoint(2, 30), _ScatterPoint(3, 42),
      _ScatterPoint(4, 26), _ScatterPoint(5, 39), _ScatterPoint(6, 48),
      _ScatterPoint(7, 32), _ScatterPoint(8, 55), _ScatterPoint(9, 41),
      _ScatterPoint(10, 64), _ScatterPoint(11, 35), _ScatterPoint(12, 47),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Scatter Chart',
      currentRoute: RouteNames.scatterChart,
      body: ChartWrapper(
        title: 'Scatter Plot with Configurable Markers',
        subtitle: 'Two sample datasets plotted as scatter points',
        configPanel: ChartConfigPanel(
          children: [
            ConfigDropdown<DataMarkerType>(
              label: 'Shape:',
              value: _markerShape,
              items: _shapeLabels.keys.toList(),
              labelBuilder: (s) => _shapeLabels[s]!,
              onChanged: (v) => setState(() => _markerShape = v),
            ),
            ConfigSlider(
              label: 'Size:',
              value: _markerSize,
              min: 4,
              max: 24,
              divisions: 20,
              onChanged: (v) => setState(() => _markerSize = v),
            ),
            ConfigSlider(
              label: 'Opacity:',
              value: _opacity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: (v) => setState(() => _opacity = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const NumericAxis(title: AxisTitle(text: 'X Value')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Y Value')),
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<_ScatterPoint, double>>[
            ScatterSeries<_ScatterPoint, double>(
              name: 'Dataset A',
              dataSource: _seriesA,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              color: const Color(0xFF5B8DEF),
              opacity: _opacity,
              markerSettings: MarkerSettings(
                isVisible: true,
                shape: _markerShape,
                width: _markerSize,
                height: _markerSize,
              ),
            ),
            ScatterSeries<_ScatterPoint, double>(
              name: 'Dataset B',
              dataSource: _seriesB,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              color: const Color(0xFFFF7043),
              opacity: _opacity,
              markerSettings: MarkerSettings(
                isVisible: true,
                shape: _markerShape,
                width: _markerSize,
                height: _markerSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
