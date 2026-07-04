import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _ProductData {
  final String product;
  final double sales;

  _ProductData(this.product, this.sales);
}

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  bool _showDataLabels = false;
  double _spacing = 0.2;

  final List<_ProductData> _data = [
    _ProductData('Electronics', 95),
    _ProductData('Clothing', 72),
    _ProductData('Furniture', 58),
    _ProductData('Food & Bev', 84),
    _ProductData('Sports', 46),
    _ProductData('Books', 33),
    _ProductData('Toys', 61),
  ];

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveScaffold(
      title: 'Bar Chart',
      currentRoute: RouteNames.barChart,
      body: ChartWrapper(
        title: 'Product Sales Comparison',
        subtitle: 'Horizontal bar comparison by product category',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Data Labels',
              value: _showDataLabels,
              onChanged: (v) => setState(() => _showDataLabels = v),
            ),
            ConfigSlider(
              label: 'Spacing',
              value: _spacing,
              min: 0,
              max: 0.5,
              divisions: 10,
              onChanged: (v) => setState(() => _spacing = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            labelFormat: '\${value}K',
          ),
          tooltipBehavior: _tooltipBehavior,
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<_ProductData, String>>[
            BarSeries<_ProductData, String>(
              name: 'Sales',
              dataSource: _data,
              xValueMapper: (d, _) => d.product,
              yValueMapper: (d, _) => d.sales,
              spacing: _spacing,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(4),
              ),
              color: colorScheme.tertiary,
              dataLabelSettings: DataLabelSettings(isVisible: _showDataLabels),
            ),
          ],
        ),
      ),
    );
  }
}
