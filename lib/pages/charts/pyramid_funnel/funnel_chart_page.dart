import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _ConversionData {
  final String stage;
  final double value;
  final Color color;
  const _ConversionData(this.stage, this.value, this.color);
}

class FunnelChartPage extends StatefulWidget {
  const FunnelChartPage({super.key});

  @override
  State<FunnelChartPage> createState() => _FunnelChartPageState();
}

class _FunnelChartPageState extends State<FunnelChartPage> {
  double _neckWidth = 20;
  double _neckHeight = 20;
  double _gapRatio = 0.03;
  bool _explode = false;

  static const _data = [
    _ConversionData('Website Visits', 10000, Color(0xFF7E57C2)),
    _ConversionData('Sign-ups', 6200, Color(0xFF5C6BC0)),
    _ConversionData('Free Trial', 3800, Color(0xFF42A5F5)),
    _ConversionData('Active Users', 2100, Color(0xFF26C6DA)),
    _ConversionData('Paid Plans', 1200, Color(0xFF26A69A)),
    _ConversionData('Enterprise', 450, Color(0xFF66BB6A)),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Funnel Chart',
      currentRoute: RouteNames.funnelChart,
      body: ChartWrapper(
        title: 'Conversion Funnel',
        subtitle: 'User journey from visit to enterprise subscription',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSlider(
              label: 'Neck Width',
              value: _neckWidth,
              min: 0,
              max: 50,
              divisions: 10,
              onChanged: (v) => setState(() => _neckWidth = v),
            ),
            ConfigSlider(
              label: 'Neck Height',
              value: _neckHeight,
              min: 0,
              max: 50,
              divisions: 10,
              onChanged: (v) => setState(() => _neckHeight = v),
            ),
            ConfigSlider(
              label: 'Gap Ratio',
              value: _gapRatio,
              min: 0,
              max: 0.5,
              divisions: 10,
              onChanged: (v) => setState(() => _gapRatio = v),
            ),
            ConfigSwitch(
              label: 'Explode',
              value: _explode,
              onChanged: (v) => setState(() => _explode = v),
            ),
          ],
        ),
        chart: SfFunnelChart(
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: FunnelSeries<_ConversionData, String>(
            dataSource: _data,
            xValueMapper: (d, _) => d.stage,
            yValueMapper: (d, _) => d.value,
            pointColorMapper: (d, _) => d.color,
            neckWidth: '${_neckWidth.toInt()}%',
            neckHeight: '${_neckHeight.toInt()}%',
            gapRatio: _gapRatio,
            explode: _explode,
            explodeGesture: ActivationMode.singleTap,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                length: '15%',
                type: ConnectorType.curve,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
