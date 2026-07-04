import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _MonthlyData {
  final String month;
  final double revenue;
  final double profit;
  final double target;
  _MonthlyData(this.month, this.revenue, this.profit, this.target);
}

class CombinationChartPage extends StatefulWidget {
  const CombinationChartPage({super.key});

  @override
  State<CombinationChartPage> createState() => _CombinationChartPageState();
}

class _CombinationChartPageState extends State<CombinationChartPage> {
  bool _showRevenue = true;
  bool _showProfit = true;
  bool _showTarget = true;

  final List<_MonthlyData> _data = [
    _MonthlyData('Jan', 420, 105, 400),
    _MonthlyData('Feb', 380, 90, 410),
    _MonthlyData('Mar', 450, 125, 420),
    _MonthlyData('Apr', 470, 140, 430),
    _MonthlyData('May', 520, 160, 440),
    _MonthlyData('Jun', 490, 135, 450),
    _MonthlyData('Jul', 550, 175, 460),
    _MonthlyData('Aug', 580, 190, 470),
    _MonthlyData('Sep', 530, 155, 480),
    _MonthlyData('Oct', 610, 210, 490),
    _MonthlyData('Nov', 640, 225, 500),
    _MonthlyData('Dec', 690, 250, 510),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Combination Chart',
      currentRoute: RouteNames.combinationChart,
      body: ChartWrapper(
        title: 'Revenue, Profit & Target — Combined View',
        subtitle: 'Columns, line, and spline on a single chart',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSwitch(
              label: 'Revenue',
              value: _showRevenue,
              onChanged: (v) => setState(() => _showRevenue = v),
            ),
            ConfigSwitch(
              label: 'Profit',
              value: _showProfit,
              onChanged: (v) => setState(() => _showProfit = v),
            ),
            ConfigSwitch(
              label: 'Target',
              value: _showTarget,
              onChanged: (v) => setState(() => _showTarget = v),
            ),
          ],
        ),
        chart: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Month'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Amount (\$K)'),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CartesianSeries<_MonthlyData, String>>[
            if (_showRevenue)
              ColumnSeries<_MonthlyData, String>(
                name: 'Revenue',
                dataSource: _data,
                xValueMapper: (d, _) => d.month,
                yValueMapper: (d, _) => d.revenue,
                color: const Color(0xFF42A5F5),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
            if (_showProfit)
              LineSeries<_MonthlyData, String>(
                name: 'Profit',
                dataSource: _data,
                xValueMapper: (d, _) => d.month,
                yValueMapper: (d, _) => d.profit,
                color: const Color(0xFF66BB6A),
                width: 2.5,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  width: 8,
                  height: 8,
                ),
              ),
            if (_showTarget)
              SplineSeries<_MonthlyData, String>(
                name: 'Target',
                dataSource: _data,
                xValueMapper: (d, _) => d.month,
                yValueMapper: (d, _) => d.target,
                color: const Color(0xFFEF5350),
                width: 2,
                dashArray: const <double>[6, 3],
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.diamond,
                  width: 7,
                  height: 7,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
