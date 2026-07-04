import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/charts/chart_config_panel.dart';
import 'package:general_reports/routing/route_names.dart';

class _ExpenseData {
  final String category;
  final double amount;
  final Color color;
  const _ExpenseData(this.category, this.amount, this.color);
}

const _data = <_ExpenseData>[
  _ExpenseData('Housing', 1850, Color(0xFF5470C6)),
  _ExpenseData('Food', 720, Color(0xFF91CC75)),
  _ExpenseData('Transport', 430, Color(0xFFFAC858)),
  _ExpenseData('Healthcare', 310, Color(0xFFEE6666)),
  _ExpenseData('Education', 540, Color(0xFF73C0DE)),
  _ExpenseData('Entertainment', 280, Color(0xFF3BA272)),
  _ExpenseData('Savings', 870, Color(0xFFFC8452)),
];

double get _total => _data.fold(0.0, (sum, d) => sum + d.amount);

class DoughnutChartPage extends StatefulWidget {
  const DoughnutChartPage({super.key});

  @override
  State<DoughnutChartPage> createState() => _DoughnutChartPageState();
}

class _DoughnutChartPageState extends State<DoughnutChartPage> {
  double _innerRadius = 60;
  double _startAngle = 0;
  double _endAngle = 360;
  bool _explode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Doughnut Chart',
      currentRoute: RouteNames.doughnutChart,
      body: ChartWrapper(
        title: 'Monthly Expense Distribution',
        subtitle: 'Household budget breakdown – June 2025',
        configPanel: ChartConfigPanel(
          children: [
            ConfigSlider(
              label: 'Inner Radius',
              value: _innerRadius,
              min: 30,
              max: 85,
              divisions: 11,
              onChanged: (v) => setState(() => _innerRadius = v),
            ),
            ConfigSlider(
              label: 'Start Angle',
              value: _startAngle,
              min: 0,
              max: 360,
              divisions: 12,
              onChanged: (v) => setState(() => _startAngle = v),
            ),
            ConfigSlider(
              label: 'End Angle',
              value: _endAngle,
              min: 0,
              max: 360,
              divisions: 12,
              onChanged: (v) => setState(() => _endAngle = v),
            ),
            ConfigSwitch(
              label: 'Explode',
              value: _explode,
              onChanged: (v) => setState(() => _explode = v),
            ),
          ],
        ),
        chart: SfCircularChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            format: 'point.x: \$point.y',
          ),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${_total.toStringAsFixed(0)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Total',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
          series: <CircularSeries<_ExpenseData, String>>[
            DoughnutSeries<_ExpenseData, String>(
              dataSource: _data,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.amount,
              pointColorMapper: (d, _) => d.color,
              innerRadius: '${_innerRadius.round()}%',
              startAngle: _startAngle.round(),
              endAngle: _endAngle.round(),
              explode: _explode,
              explodeOffset: '8%',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve,
                  length: '12%',
                ),
                useSeriesColor: true,
              ),
              dataLabelMapper: (d, _) =>
                  '${d.category}\n\$${d.amount.toStringAsFixed(0)}',
              animationDuration: 800,
            ),
          ],
        ),
      ),
    );
  }
}
