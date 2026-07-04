import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/routing/route_names.dart';

class _WaterfallData {
  final String category;
  final double value;
  final bool isTotal;
  final bool isIntermediate;
  _WaterfallData(this.category, this.value,
      {this.isTotal = false, this.isIntermediate = false});
}

class WaterfallChartPage extends StatefulWidget {
  const WaterfallChartPage({super.key});

  @override
  State<WaterfallChartPage> createState() => _WaterfallChartPageState();
}

class _WaterfallChartPageState extends State<WaterfallChartPage> {
  final List<_WaterfallData> _data = [
    _WaterfallData('Revenue', 4200),
    _WaterfallData('COGS', -1800),
    _WaterfallData('Gross Profit', 0, isIntermediate: true),
    _WaterfallData('Marketing', -450),
    _WaterfallData('R&D', -620),
    _WaterfallData('Salaries', -850),
    _WaterfallData('Admin', -180),
    _WaterfallData('Operating\nIncome', 0, isIntermediate: true),
    _WaterfallData('Interest', -90),
    _WaterfallData('Tax', -63),
    _WaterfallData('Other', 35),
    _WaterfallData('Net Income', 0, isTotal: true),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Waterfall Chart',
      currentRoute: RouteNames.waterfallChart,
      body: ChartWrapper(
        title: 'Profit & Loss Waterfall',
        subtitle: 'Annual P&L breakdown (values in \$K)',
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Amount (\$K)'),
            numberFormat: null,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_WaterfallData, String>>[
            WaterfallSeries<_WaterfallData, String>(
              dataSource: _data,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
              intermediateSumPredicate: (d, _) => d.isIntermediate,
              totalSumPredicate: (d, _) => d.isTotal,
              negativePointsColor: const Color(0xFFEF5350),
              color: const Color(0xFF42A5F5),
              intermediateSumColor: const Color(0xFF78909C),
              totalSumColor: const Color(0xFF26A69A),
              connectorLineSettings: const WaterfallConnectorLineSettings(
                dashArray: <double>[3, 2],
                color: Colors.black54,
              ),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.outer,
                textStyle: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
