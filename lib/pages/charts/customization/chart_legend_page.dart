import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartLegendPage extends StatefulWidget {
  const ChartLegendPage({super.key});

  @override
  State<ChartLegendPage> createState() => _ChartLegendPageState();
}

class _ChartLegendPageState extends State<ChartLegendPage> {
  LegendPosition _position = LegendPosition.bottom;
  bool _isVisible = true;
  bool _toggleVisibility = true;
  LegendItemOverflowMode _overflowMode = LegendItemOverflowMode.wrap;
  double _iconHeight = 12;
  double _iconWidth = 12;
  bool _useTemplate = false;

  final List<_SalesData> _data = const [
    _SalesData('Jan', 35, 28, 20),
    _SalesData('Feb', 28, 34, 24),
    _SalesData('Mar', 38, 30, 22),
    _SalesData('Apr', 32, 40, 28),
    _SalesData('May', 40, 36, 32),
    _SalesData('Jun', 45, 42, 26),
    _SalesData('Jul', 48, 38, 30),
    _SalesData('Aug', 42, 44, 34),
    _SalesData('Sep', 50, 46, 36),
    _SalesData('Oct', 55, 48, 40),
    _SalesData('Nov', 52, 50, 38),
    _SalesData('Dec', 60, 54, 44),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Chart Legend',
      currentRoute: RouteNames.chartLegend,
      body: ChartWrapper(
        title: 'Legend Customization',
        subtitle: 'Position, overflow, toggle, icon size & templates',
        configPanel: ChartConfigPanel(children: [
          ConfigSwitch(
            label: 'Visible',
            value: _isVisible,
            onChanged: (v) => setState(() => _isVisible = v),
          ),
          ConfigSwitch(
            label: 'Toggle Series',
            value: _toggleVisibility,
            onChanged: (v) => setState(() => _toggleVisibility = v),
          ),
          ConfigSwitch(
            label: 'Custom Template',
            value: _useTemplate,
            onChanged: (v) => setState(() => _useTemplate = v),
          ),
          ConfigDropdown<LegendPosition>(
            label: 'Position',
            value: _position,
            items: LegendPosition.values,
            onChanged: (v) => setState(() => _position = v),
            labelBuilder: (v) => v.name,
          ),
          ConfigDropdown<LegendItemOverflowMode>(
            label: 'Overflow',
            value: _overflowMode,
            items: LegendItemOverflowMode.values,
            onChanged: (v) => setState(() => _overflowMode = v),
            labelBuilder: (v) => v.name,
          ),
          ConfigSlider(
            label: 'Icon Size',
            value: _iconHeight,
            min: 6,
            max: 24,
            divisions: 18,
            onChanged: (v) => setState(() {
              _iconHeight = v;
              _iconWidth = v;
            }),
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            labelFormat: '{value}K',
            minimum: 0,
            maximum: 70,
            interval: 10,
          ),
          legend: Legend(
            isVisible: _isVisible,
            position: _position,
            overflowMode: _overflowMode,
            toggleSeriesVisibility: _toggleVisibility,
            iconHeight: _iconHeight,
            iconWidth: _iconWidth,
            legendItemBuilder: _useTemplate ? _legendItemBuilder : null,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_SalesData, String>>[
            SplineSeries<_SalesData, String>(
              name: 'Online',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.online,
              color: const Color(0xFF1565C0),
              width: 2.5,
            ),
            SplineSeries<_SalesData, String>(
              name: 'Retail',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.retail,
              color: const Color(0xFF00897B),
              width: 2.5,
            ),
            SplineSeries<_SalesData, String>(
              name: 'Wholesale',
              dataSource: _data,
              xValueMapper: (d, _) => d.month,
              yValueMapper: (d, _) => d.wholesale,
              color: const Color(0xFFF57C00),
              width: 2.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItemBuilder(
    String legendText,
    ChartSeries<dynamic, dynamic>? series,
    ChartPoint<dynamic> point,
    int seriesIndex,
  ) {
    final colors = [
      const Color(0xFF1565C0),
      const Color(0xFF00897B),
      const Color(0xFFF57C00),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: colors[seriesIndex % colors.length],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(legendText, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SalesData {
  final String month;
  final double online;
  final double retail;
  final double wholesale;

  const _SalesData(this.month, this.online, this.retail, this.wholesale);
}
