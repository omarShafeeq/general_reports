import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartTooltipPage extends StatefulWidget {
  const ChartTooltipPage({super.key});

  @override
  State<ChartTooltipPage> createState() => _ChartTooltipPageState();
}

class _ChartTooltipPageState extends State<ChartTooltipPage> {
  bool _shared = false;
  bool _canShowMarker = true;
  bool _useBuilder = false;
  String _format = 'point.x : point.y';

  final List<_ProductData> _data = const [
    _ProductData('Mon', 12, 8),
    _ProductData('Tue', 15, 11),
    _ProductData('Wed', 18, 14),
    _ProductData('Thu', 22, 16),
    _ProductData('Fri', 20, 19),
    _ProductData('Sat', 28, 23),
    _ProductData('Sun', 25, 21),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Chart Tooltip',
      currentRoute: RouteNames.chartTooltip,
      body: ChartWrapper(
        title: 'Tooltip Customization',
        subtitle: 'Format, shared tooltip, marker, custom builder',
        configPanel: ChartConfigPanel(children: [
          ConfigSwitch(
            label: 'Shared Tooltip',
            value: _shared,
            onChanged: (v) => setState(() => _shared = v),
          ),
          ConfigSwitch(
            label: 'Show Marker',
            value: _canShowMarker,
            onChanged: (v) => setState(() => _canShowMarker = v),
          ),
          ConfigSwitch(
            label: 'Custom Builder',
            value: _useBuilder,
            onChanged: (v) => setState(() => _useBuilder = v),
          ),
          ConfigDropdown<String>(
            label: 'Format',
            value: _format,
            items: const [
              'point.x : point.y',
              'point.y units',
              'series.name - point.y',
            ],
            onChanged: (v) => setState(() => _format = v),
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            labelFormat: '{value}',
            minimum: 0,
            maximum: 35,
          ),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            shared: _shared,
            canShowMarker: _canShowMarker,
            format: _useBuilder ? null : _format,
            header: _useBuilder ? '' : 'Sales',
            builder: _useBuilder ? _tooltipBuilder : null,
          ),
          series: <CartesianSeries<_ProductData, String>>[
            ColumnSeries<_ProductData, String>(
              name: 'Product A',
              dataSource: _data,
              xValueMapper: (d, _) => d.day,
              yValueMapper: (d, _) => d.productA,
              color: const Color(0xFF1565C0),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            ColumnSeries<_ProductData, String>(
              name: 'Product B',
              dataSource: _data,
              xValueMapper: (d, _) => d.day,
              yValueMapper: (d, _) => d.productB,
              color: const Color(0xFF00897B),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tooltipBuilder(
    dynamic data,
    dynamic point,
    dynamic series,
    int pointIndex,
    int seriesIndex,
  ) {
    final d = data as _ProductData;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            d.day,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onInverseSurface,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Value: ${seriesIndex == 0 ? d.productA : d.productB}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onInverseSurface,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductData {
  final String day;
  final double productA;
  final double productB;

  const _ProductData(this.day, this.productA, this.productB);
}
