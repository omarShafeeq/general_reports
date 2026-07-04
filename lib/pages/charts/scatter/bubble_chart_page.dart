import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _BubbleData {
  final double x;
  final double y;
  final double size;
  final String label;
  _BubbleData(this.x, this.y, this.size, this.label);
}

class BubbleChartPage extends StatefulWidget {
  const BubbleChartPage({super.key});

  @override
  State<BubbleChartPage> createState() => _BubbleChartPageState();
}

class _BubbleChartPageState extends State<BubbleChartPage> {
  double _minRadius = 4;
  double _maxRadius = 30;
  double _opacity = 0.75;

  final List<_BubbleData> _data = [
    _BubbleData(92, 7.8, 1411, 'China'),
    _BubbleData(74, 6.9, 1380, 'India'),
    _BubbleData(65, 7.0, 331, 'USA'),
    _BubbleData(56, 5.6, 273, 'Indonesia'),
    _BubbleData(68, 6.4, 213, 'Brazil'),
    _BubbleData(77, 5.3, 200, 'Nigeria'),
    _BubbleData(80, 5.9, 146, 'Russia'),
    _BubbleData(84, 7.5, 126, 'Japan'),
    _BubbleData(46, 4.9, 225, 'Pakistan'),
    _BubbleData(83, 6.1, 67, 'France'),
    _BubbleData(88, 7.3, 51, 'S. Korea'),
    _BubbleData(72, 6.6, 115, 'Mexico'),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Bubble Chart',
      currentRoute: RouteNames.bubbleChart,
      body: ChartWrapper(
        title: 'World Demographics — Bubble Chart',
        subtitle: 'X: Literacy %, Y: Happiness, Size: Population (millions)',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSlider(
              label: 'Min Radius:',
              value: _minRadius,
              min: 2,
              max: 15,
              divisions: 13,
              onChanged: (v) => setState(() => _minRadius = v),
            ),
            ConfigSlider(
              label: 'Max Radius:',
              value: _maxRadius,
              min: 15,
              max: 50,
              divisions: 35,
              onChanged: (v) => setState(() => _maxRadius = v),
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
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Literacy Rate (%)'),
            minimum: 40,
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Happiness Index'),
            minimum: 4,
            maximum: 9,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            format: 'point.x% literacy, point.y happiness',
          ),
          series: <CartesianSeries<_BubbleData, double>>[
            BubbleSeries<_BubbleData, double>(
              dataSource: _data,
              xValueMapper: (d, _) => d.x,
              yValueMapper: (d, _) => d.y,
              sizeValueMapper: (d, _) => d.size,
              minimumRadius: _minRadius,
              maximumRadius: _maxRadius,
              opacity: _opacity,
              dataLabelMapper: (d, _) => d.label,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.middle,
                textStyle: TextStyle(fontSize: 10),
              ),
              color: const Color(0xFF26A69A),
            ),
          ],
        ),
      ),
    );
  }
}
