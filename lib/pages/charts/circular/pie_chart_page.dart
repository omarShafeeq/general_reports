import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _MarketData {
  final String segment;
  final double share;
  final Color color;
  const _MarketData(this.segment, this.share, this.color);
}

const _data = <_MarketData>[
  _MarketData('Cloud Services', 32, Color(0xFF5B8FF9)),
  _MarketData('Enterprise SW', 22, Color(0xFF5AD8A6)),
  _MarketData('Cybersecurity', 16, Color(0xFFF6BD16)),
  _MarketData('AI / ML', 13, Color(0xFFE86452)),
  _MarketData('IoT', 9, Color(0xFF6DC8EC)),
  _MarketData('Other', 8, Color(0xFF945FB9)),
];

class PieChartPage extends StatefulWidget {
  const PieChartPage({super.key});

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  bool _showDataLabels = true;
  bool _explode = false;
  bool _smartLabels = true;
  LegendPosition _legendPosition = LegendPosition.bottom;
  int _explodeIndex = 0;
  double _explodeOffset = 10;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Pie Chart',
      currentRoute: RouteNames.pieChart,
      body: ChartWrapper(
        title: 'Tech Market Share',
        subtitle: 'Global market segmentation – 2025',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Data Labels',
              value: _showDataLabels,
              onChanged: (v) => setState(() => _showDataLabels = v),
            ),
            ConfigSwitch(
              label: 'Explode',
              value: _explode,
              onChanged: (v) => setState(() => _explode = v),
            ),
            ConfigSwitch(
              label: 'Smart Labels',
              value: _smartLabels,
              onChanged: (v) => setState(() => _smartLabels = v),
            ),
            ConfigDropdown<LegendPosition>(
              label: 'Legend',
              value: _legendPosition,
              items: LegendPosition.values,
              onChanged: (v) => setState(() => _legendPosition = v),
              labelBuilder: (p) => p.name[0].toUpperCase() + p.name.substring(1),
            ),
            if (_explode)
              ConfigSlider(
                label: 'Explode Index',
                value: _explodeIndex.toDouble(),
                min: 0,
                max: (_data.length - 1).toDouble(),
                divisions: _data.length - 1,
                onChanged: (v) => setState(() => _explodeIndex = v.round()),
              ),
            if (_explode)
              ConfigSlider(
                label: 'Offset',
                value: _explodeOffset,
                min: 0,
                max: 30,
                divisions: 6,
                onChanged: (v) => setState(() => _explodeOffset = v),
              ),
          ],
        ),
        chart: SfCircularChart(
          legend: Legend(
            isVisible: true,
            position: _legendPosition,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CircularSeries<_MarketData, String>>[
            PieSeries<_MarketData, String>(
              dataSource: _data,
              xValueMapper: (d, _) => d.segment,
              yValueMapper: (d, _) => d.share,
              pointColorMapper: (d, _) => d.color,
              dataLabelSettings: DataLabelSettings(
                isVisible: _showDataLabels,
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: const ConnectorLineSettings(
                  type: ConnectorType.curve,
                  length: '15%',
                ),
                useSeriesColor: true,
                overflowMode: _smartLabels
                    ? OverflowMode.shift
                    : OverflowMode.none,
              ),
              dataLabelMapper: (d, _) => '${d.segment}\n${d.share}%',
              explode: _explode,
              explodeIndex: _explodeIndex,
              explodeOffset: '${_explodeOffset.round()}%',
              animationDuration: 800,
            ),
          ],
        ),
      ),
    );
  }
}
