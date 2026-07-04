import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartSelectionPage extends StatefulWidget {
  const ChartSelectionPage({super.key});

  @override
  State<ChartSelectionPage> createState() => _ChartSelectionPageState();
}

class _ChartSelectionPageState extends State<ChartSelectionPage> {
  SelectionType _selectionType = SelectionType.point;
  bool _enableMultiSelection = false;
  Color _selectionColor = const Color(0xFF1565C0);
  double _unselectedOpacity = 0.3;

  final List<_MarketData> _data = const [
    _MarketData('Electronics', 35, 28, 22),
    _MarketData('Clothing', 28, 32, 18),
    _MarketData('Food', 42, 38, 30),
    _MarketData('Furniture', 20, 24, 16),
    _MarketData('Sports', 32, 30, 26),
    _MarketData('Books', 18, 22, 14),
  ];

  @override
  Widget build(BuildContext context) {
    final unselectedColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(_unselectedOpacity)
        : Colors.grey.withOpacity(_unselectedOpacity);

    return ResponsiveScaffold(
      title: 'Chart Selection',
      currentRoute: RouteNames.chartSelection,
      body: ChartWrapper(
        title: 'Selection Behavior',
        subtitle: 'Point, series, cluster selection with multi-select',
        configPanel: ChartConfigPanel(children: [
          ConfigDropdown<SelectionType>(
            label: 'Selection Type',
            value: _selectionType,
            items: SelectionType.values,
            onChanged: (v) => setState(() => _selectionType = v),
            labelBuilder: (v) => v.name,
          ),
          ConfigSwitch(
            label: 'Multi-Select',
            value: _enableMultiSelection,
            onChanged: (v) => setState(() => _enableMultiSelection = v),
          ),
          ConfigDropdown<Color>(
            label: 'Sel. Color',
            value: _selectionColor,
            items: const [
              Color(0xFF1565C0),
              Color(0xFFD81B60),
              Color(0xFF43A047),
              Color(0xFFF57C00),
            ],
            onChanged: (v) => setState(() => _selectionColor = v),
            labelBuilder: (v) {
              const names = {
                0xFF1565C0: 'Blue',
                0xFFD81B60: 'Pink',
                0xFF43A047: 'Green',
                0xFFF57C00: 'Orange',
              };
              return names[v.value] ?? 'Color';
            },
          ),
          ConfigSlider(
            label: 'Unsel. Opacity',
            value: _unselectedOpacity,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            onChanged: (v) => setState(() => _unselectedOpacity = v),
          ),
        ]),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            maximum: 50,
            interval: 10,
            labelFormat: '{value}K',
          ),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          selectionType: _selectionType,
          enableMultiSelection: _enableMultiSelection,
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_MarketData, String>>[
            ColumnSeries<_MarketData, String>(
              name: 'Online',
              dataSource: _data,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.online,
              color: const Color(0xFF1565C0),
              selectionBehavior: SelectionBehavior(
                enable: true,
                selectedColor: _selectionColor,
                unselectedColor: unselectedColor,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            ColumnSeries<_MarketData, String>(
              name: 'Retail',
              dataSource: _data,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.retail,
              color: const Color(0xFF00897B),
              selectionBehavior: SelectionBehavior(
                enable: true,
                selectedColor: _selectionColor,
                unselectedColor: unselectedColor,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            ColumnSeries<_MarketData, String>(
              name: 'Wholesale',
              dataSource: _data,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.wholesale,
              color: const Color(0xFFF57C00),
              selectionBehavior: SelectionBehavior(
                enable: true,
                selectedColor: _selectionColor,
                unselectedColor: unselectedColor,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketData {
  final String category;
  final double online;
  final double retail;
  final double wholesale;
  const _MarketData(this.category, this.online, this.retail, this.wholesale);
}
