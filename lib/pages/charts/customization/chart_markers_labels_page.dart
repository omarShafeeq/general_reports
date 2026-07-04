import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartMarkersLabelsPage extends StatefulWidget {
  const ChartMarkersLabelsPage({super.key});

  @override
  State<ChartMarkersLabelsPage> createState() =>
      _ChartMarkersLabelsPageState();
}

class _ChartMarkersLabelsPageState extends State<ChartMarkersLabelsPage> {
  DataMarkerType _markerShape = DataMarkerType.circle;
  double _markerSize = 8;
  ChartDataLabelPosition _labelPosition = ChartDataLabelPosition.outside;
  bool _showLabels = true;
  bool _useCustomBuilder = false;

  final List<_ScoreData> _data = const [
    _ScoreData('Math', 88),
    _ScoreData('Science', 76),
    _ScoreData('English', 92),
    _ScoreData('History', 65),
    _ScoreData('Art', 80),
    _ScoreData('Music', 70),
    _ScoreData('Sports', 95),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Markers & Labels',
      currentRoute: RouteNames.chartMarkersLabels,
      body: ChartWrapper(
        title: 'Marker & Data Label Customization',
        subtitle: 'Shape, size, color, label position, custom builder',
        configPanel: ChartConfigPanel(children: [
          ConfigDropdown<DataMarkerType>(
            label: 'Marker Shape',
            value: _markerShape,
            items: DataMarkerType.values,
            onChanged: (v) => setState(() => _markerShape = v),
            labelBuilder: (v) => v.name,
          ),
          ConfigSlider(
            label: 'Marker Size',
            value: _markerSize,
            min: 4,
            max: 16,
            divisions: 12,
            onChanged: (v) => setState(() => _markerSize = v),
          ),
          ConfigSwitch(
            label: 'Data Labels',
            value: _showLabels,
            onChanged: (v) => setState(() => _showLabels = v),
          ),
          ConfigDropdown<ChartDataLabelPosition>(
            label: 'Label Pos',
            value: _labelPosition,
            items: ChartDataLabelPosition.values,
            onChanged: (v) => setState(() => _labelPosition = v),
            labelBuilder: (v) => v.name,
          ),
          ConfigSwitch(
            label: 'Custom Label',
            value: _useCustomBuilder,
            onChanged: (v) => setState(() => _useCustomBuilder = v),
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            maximum: 100,
            interval: 20,
            labelFormat: '{value}%',
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_ScoreData, String>>[
            LineSeries<_ScoreData, String>(
              dataSource: _data,
              xValueMapper: (d, _) => d.subject,
              yValueMapper: (d, _) => d.score,
              color: const Color(0xFF1565C0),
              width: 2.5,
              markerSettings: MarkerSettings(
                isVisible: true,
                shape: _markerShape,
                height: _markerSize,
                width: _markerSize,
                color: const Color(0xFF1565C0),
                borderColor: Colors.white,
                borderWidth: 2,
              ),
              dataLabelSettings: DataLabelSettings(
                isVisible: _showLabels,
                labelPosition: _labelPosition,
                textStyle: const TextStyle(fontSize: 11),
                builder: _useCustomBuilder ? _labelBuilder : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelBuilder(
    dynamic data,
    dynamic point,
    dynamic series,
    int pointIndex,
    int seriesIndex,
  ) {
    final d = data as _ScoreData;
    final color = d.score >= 80
        ? const Color(0xFF43A047)
        : d.score >= 60
            ? const Color(0xFFF57C00)
            : const Color(0xFFE53935);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${d.score}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ScoreData {
  final String subject;
  final double score;
  const _ScoreData(this.subject, this.score);
}
