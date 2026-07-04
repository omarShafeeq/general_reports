import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _FunnelData {
  final String stage;
  final double value;
  final Color color;
  const _FunnelData(this.stage, this.value, this.color);
}

class PyramidChartPage extends StatefulWidget {
  const PyramidChartPage({super.key});

  @override
  State<PyramidChartPage> createState() => _PyramidChartPageState();
}

class _PyramidChartPageState extends State<PyramidChartPage> {
  double _gapRatio = 0.05;
  bool _explode = false;
  bool _showDataLabels = true;

  static const _data = [
    _FunnelData('Leads', 4200, Color(0xFF5C6BC0)),
    _FunnelData('Qualified', 2800, Color(0xFF42A5F5)),
    _FunnelData('Proposals', 1500, Color(0xFF26A69A)),
    _FunnelData('Negotiation', 900, Color(0xFFFFA726)),
    _FunnelData('Closed Won', 520, Color(0xFF66BB6A)),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Pyramid Chart',
      currentRoute: RouteNames.pyramidChart,
      body: ChartWrapper(
        title: 'Sales Funnel',
        subtitle: 'Lead-to-close conversion pipeline',
        configPanel: ChartConfigPanel(
          children: [
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
            ConfigSwitch(
              label: 'Data Labels',
              value: _showDataLabels,
              onChanged: (v) => setState(() => _showDataLabels = v),
            ),
          ],
        ),
        chart: SfPyramidChart(
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: PyramidSeries<_FunnelData, String>(
            dataSource: _data,
            xValueMapper: (d, _) => d.stage,
            yValueMapper: (d, _) => d.value,
            pointColorMapper: (d, _) => d.color,
            gapRatio: _gapRatio,
            explode: _explode,
            explodeGesture: ActivationMode.singleTap,
            dataLabelSettings: DataLabelSettings(
              isVisible: _showDataLabels,
              labelPosition: ChartDataLabelPosition.inside,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
