import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../models/chart_definition.dart';
import '../models/enums.dart';

class DynamicChartRenderer extends StatelessWidget {
  final ChartDefinition definition;
  final List<Map<String, dynamic>> data;
  final void Function(Map<String, dynamic> point)? onPointTap;
  final bool documentMode;

  const DynamicChartRenderer({
    super.key,
    required this.definition,
    required this.data,
    this.onPointTap,
    this.documentMode = false,
  });

  static const _documentTeal = Color(0xFF00897B);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            color: documentMode
                ? const Color(0xFF757575)
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    if (documentMode) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(48, 8, 48, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              definition.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF424242),
              ),
            ),
            if (definition.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                definition.subtitle!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF757575),
                ),
              ),
            ],
            const SizedBox(height: 6),
            Container(
              height: 3,
              color: _documentTeal,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 280,
              child: _buildChart(),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md, AppSizes.md, AppSizes.md, 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  definition.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (definition.subtitle != null)
                  Text(
                    definition.subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: _buildChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    if (definition.isCircular) return _buildCircularChart();
    if (definition.isFunnel) {
      return definition.chartType == ReportChartType.funnel
          ? _buildFunnelChart()
          : _buildPyramidChart();
    }
    return _buildCartesianChart();
  }

  SelectionBehavior? get _selectionBehavior {
    if (onPointTap != null) return SelectionBehavior(enable: true);
    final sel = definition.selection;
    if (sel == null || !sel.enabled) return null;
    return SelectionBehavior(
      enable: true,
      toggleSelection: true,
    );
  }

  // ── Cartesian Charts ────────────────────────────────────────────────

  Widget _buildCartesianChart() {
    return SfCartesianChart(
      palette: definition.palette ?? AppColors.chartPalette,
      legend: _buildLegend(),
      tooltipBehavior: _buildTooltip(),
      trackballBehavior: _buildTrackball(),
      crosshairBehavior: _buildCrosshair(),
      zoomPanBehavior: _buildZoomPan(),
      primaryXAxis: _buildXAxis(),
      primaryYAxis: _buildYAxis(),
      series: _buildCartesianSeries(),
      enableMultiSelection: definition.selection?.enableMultiSelection ?? false,
      onSelectionChanged: onPointTap != null
          ? (SelectionArgs args) {
              if (args.pointIndex < data.length) {
                onPointTap!(data[args.pointIndex]);
              }
            }
          : null,
    );
  }

  List<CartesianSeries<Map<String, dynamic>, dynamic>> _buildCartesianSeries() {
    return definition.yFields
        .map((yField) => _createCartesianSeries(yField))
        .toList();
  }

  dynamic Function(Map<String, dynamic>, int) _xMapper() =>
      (Map<String, dynamic> d, int i) => d[definition.xField];

  num? Function(Map<String, dynamic>, int) _yMapper(String yField) =>
      (Map<String, dynamic> d, int i) => (d[yField] as num?)?.toDouble();

  DataLabelSettings _buildDataLabelSettings() {
    final cfg = definition.dataLabels;
    if (cfg == null || !cfg.visible) {
      return const DataLabelSettings(isVisible: false);
    }
    return DataLabelSettings(
      isVisible: true,
      labelAlignment: _mapLabelPosition(cfg.position),
    );
  }

  ChartDataLabelAlignment _mapLabelPosition(String position) {
    switch (position) {
      case 'outer':
        return ChartDataLabelAlignment.outer;
      case 'inside':
        return ChartDataLabelAlignment.middle;
      case 'outside':
        return ChartDataLabelAlignment.outer;
      default:
        return ChartDataLabelAlignment.auto;
    }
  }

  CartesianSeries<Map<String, dynamic>, dynamic> _createCartesianSeries(
    String yField,
  ) {
    final xMap = _xMapper();
    final yMap = _yMapper(yField);
    final name = _formatFieldName(yField);
    final sel = _selectionBehavior;
    final dlSettings = _buildDataLabelSettings();
    final animate = documentMode ? false : definition.enableAnimation;
    final animDur = definition.animationDuration;

    switch (definition.chartType) {
      case ReportChartType.line:
        return LineSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
          markerSettings: const MarkerSettings(isVisible: true, height: 4, width: 4),
        );
      case ReportChartType.spline:
        return SplineSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.area:
        return AreaSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel, opacity: 0.6,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.splineArea:
        return SplineAreaSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel, opacity: 0.6,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.stepLine:
        return StepLineSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.stepArea:
        return StepAreaSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel, opacity: 0.6,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.bar:
        return BarSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.column:
        return ColumnSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.stackedColumn:
        return StackedColumnSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.stackedBar:
        return StackedBarSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.stackedArea:
        return StackedAreaSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel, opacity: 0.6,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.stackedColumn100:
        return StackedColumn100Series<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.stackedBar100:
        return StackedBar100Series<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.rangeColumn:
        return RangeColumnSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap,
          lowValueMapper: yMap,
          highValueMapper: (Map<String, dynamic> d, int i) =>
              (d['${yField}High'] as num?)?.toDouble() ?? yMap(d, i),
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.rangeArea:
        return RangeAreaSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap,
          lowValueMapper: yMap,
          highValueMapper: (Map<String, dynamic> d, int i) =>
              (d['${yField}High'] as num?)?.toDouble() ?? yMap(d, i),
          name: name, selectionBehavior: sel, opacity: 0.6,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.scatter:
        return ScatterSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.bubble:
        return BubbleSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          sizeValueMapper: (Map<String, dynamic> d, int i) =>
              (d['${yField}Size'] as num?)?.toDouble() ?? 5,
          name: name, selectionBehavior: sel,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.waterfall:
        return WaterfallSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.histogram:
        return HistogramSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.candle:
        return CandleSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          xValueMapper: xMap,
          openValueMapper: (d, i) => (d['open'] as num?)?.toDouble(),
          highValueMapper: (d, i) => (d['high'] as num?)?.toDouble(),
          lowValueMapper: (d, i) => (d['low'] as num?)?.toDouble(),
          closeValueMapper: (d, i) => (d['close'] as num?)?.toDouble(),
          name: name, selectionBehavior: sel,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.hilo:
        return HiloSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          xValueMapper: xMap,
          highValueMapper: (d, i) => (d['high'] as num?)?.toDouble(),
          lowValueMapper: (d, i) => (d['low'] as num?)?.toDouble(),
          name: name, selectionBehavior: sel,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.hiloOpenClose:
        return HiloOpenCloseSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          xValueMapper: xMap,
          openValueMapper: (d, i) => (d['open'] as num?)?.toDouble(),
          highValueMapper: (d, i) => (d['high'] as num?)?.toDouble(),
          lowValueMapper: (d, i) => (d['low'] as num?)?.toDouble(),
          closeValueMapper: (d, i) => (d['close'] as num?)?.toDouble(),
          name: name, selectionBehavior: sel,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.boxWhisker:
        return BoxAndWhiskerSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          xValueMapper: xMap,
          yValueMapper: (d, i) => d[yField] as List<num>?,
          name: name, selectionBehavior: sel,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      case ReportChartType.errorBar:
        return ErrorBarSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
      default:
        return ColumnSeries<Map<String, dynamic>, dynamic>(
          dataSource: data, xValueMapper: xMap, yValueMapper: yMap,
          name: name, selectionBehavior: sel,
          dataLabelSettings: dlSettings,
          animationDuration: animate ? animDur.toDouble() : 0,
        );
    }
  }

  // ── Circular Charts ─────────────────────────────────────────────────

  Widget _buildCircularChart() {
    return SfCircularChart(
      palette: definition.palette ?? AppColors.chartPalette,
      legend: _buildLegend(),
      tooltipBehavior: _buildTooltip(),
      series: [_buildCircularSeries()],
      onSelectionChanged: onPointTap != null
          ? (SelectionArgs args) {
              if (args.pointIndex < data.length) {
                onPointTap!(data[args.pointIndex]);
              }
            }
          : null,
    );
  }

  CircularSeries<Map<String, dynamic>, dynamic> _buildCircularSeries() {
    final yField = definition.yFields.first;
    final sel = _selectionBehavior;
    final dlSettings = definition.dataLabels != null && definition.dataLabels!.visible
        ? DataLabelSettings(
            isVisible: true,
            labelPosition: definition.chartType == ReportChartType.doughnut
                ? ChartDataLabelPosition.outside
                : ChartDataLabelPosition.inside,
          )
        : const DataLabelSettings(isVisible: true);

    switch (definition.chartType) {
      case ReportChartType.pie:
        return PieSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          xValueMapper: (d, i) => d[definition.xField],
          yValueMapper: (d, i) => (d[yField] as num?)?.toDouble(),
          dataLabelMapper: (d, i) => d[definition.xField]?.toString(),
          dataLabelSettings: dlSettings,
          name: _formatFieldName(yField),
          selectionBehavior: sel,
          animationDuration: definition.enableAnimation
              ? definition.animationDuration.toDouble()
              : 0,
        );
      case ReportChartType.doughnut:
        return DoughnutSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          xValueMapper: (d, i) => d[definition.xField],
          yValueMapper: (d, i) => (d[yField] as num?)?.toDouble(),
          dataLabelMapper: (d, i) => d[definition.xField]?.toString(),
          dataLabelSettings: dlSettings,
          innerRadius: '60%',
          name: _formatFieldName(yField),
          selectionBehavior: sel,
          animationDuration: definition.enableAnimation
              ? definition.animationDuration.toDouble()
              : 0,
        );
      case ReportChartType.radialBar:
        return RadialBarSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          xValueMapper: (d, i) => d[definition.xField],
          yValueMapper: (d, i) => (d[yField] as num?)?.toDouble(),
          dataLabelSettings: dlSettings,
          name: _formatFieldName(yField),
          maximumValue: definition.options?['maximumValue']?.toDouble() ?? 100,
          selectionBehavior: sel,
          animationDuration: definition.enableAnimation
              ? definition.animationDuration.toDouble()
              : 0,
        );
      default:
        return PieSeries<Map<String, dynamic>, dynamic>(
          dataSource: data,
          xValueMapper: (d, i) => d[definition.xField],
          yValueMapper: (d, i) => (d[yField] as num?)?.toDouble(),
          selectionBehavior: sel,
        );
    }
  }

  // ── Pyramid & Funnel ────────────────────────────────────────────────

  Widget _buildPyramidChart() {
    final yField = definition.yFields.first;
    return SfPyramidChart(
      palette: definition.palette ?? AppColors.chartPalette,
      legend: _buildLegend(),
      tooltipBehavior: _buildTooltip(),
      series: PyramidSeries<Map<String, dynamic>, dynamic>(
        dataSource: data,
        xValueMapper: (d, i) => d[definition.xField],
        yValueMapper: (d, i) => (d[yField] as num?)?.toDouble(),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        animationDuration: definition.enableAnimation
            ? definition.animationDuration.toDouble()
            : 0,
      ),
    );
  }

  Widget _buildFunnelChart() {
    final yField = definition.yFields.first;
    return SfFunnelChart(
      palette: definition.palette ?? AppColors.chartPalette,
      legend: _buildLegend(),
      tooltipBehavior: _buildTooltip(),
      series: FunnelSeries<Map<String, dynamic>, dynamic>(
        dataSource: data,
        xValueMapper: (d, i) => d[definition.xField],
        yValueMapper: (d, i) => (d[yField] as num?)?.toDouble(),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        animationDuration: definition.enableAnimation
            ? definition.animationDuration.toDouble()
            : 0,
      ),
    );
  }

  // ── Trackball / Crosshair / ZoomPan ─────────────────────────────────

  TrackballBehavior? _buildTrackball() {
    final cfg = definition.trackball;
    if (cfg == null || !cfg.enabled) return null;

    TrackballDisplayMode displayMode;
    switch (cfg.tooltipDisplayMode) {
      case 'floatAllPoints':
        displayMode = TrackballDisplayMode.floatAllPoints;
      case 'nearestPoint':
        displayMode = TrackballDisplayMode.nearestPoint;
      default:
        displayMode = TrackballDisplayMode.groupAllPoints;
    }

    return TrackballBehavior(
      enable: true,
      tooltipDisplayMode: displayMode,
      activationMode: _mapActivationMode(cfg.activationMode),
    );
  }

  CrosshairBehavior? _buildCrosshair() {
    final cfg = definition.crosshair;
    if (cfg == null || !cfg.enabled) return null;
    return CrosshairBehavior(
      enable: true,
      activationMode: _mapActivationMode(cfg.activationMode),
    );
  }

  ZoomPanBehavior? _buildZoomPan() {
    final cfg = definition.zoomPan;
    if (cfg == null) return null;
    return ZoomPanBehavior(
      enablePinching: cfg.enablePinching,
      enableDoubleTapZooming: cfg.enableDoubleTapZooming,
      enablePanning: cfg.enablePanning,
      enableSelectionZooming: cfg.enableSelectionZooming,
      enableMouseWheelZooming: cfg.enableMouseWheelZooming,
      zoomMode: cfg.zoomMode == 'x'
          ? ZoomMode.x
          : cfg.zoomMode == 'y'
              ? ZoomMode.y
              : ZoomMode.xy,
    );
  }

  ActivationMode _mapActivationMode(String mode) {
    switch (mode) {
      case 'singleTap':
        return ActivationMode.singleTap;
      case 'doubleTap':
        return ActivationMode.doubleTap;
      case 'longPress':
        return ActivationMode.longPress;
      default:
        return ActivationMode.singleTap;
    }
  }

  // ── Common Config ───────────────────────────────────────────────────

  Legend _buildLegend() {
    final cfg = definition.legend;
    if (cfg == null || !cfg.visible) return const Legend(isVisible: false);

    LegendPosition position;
    switch (cfg.position) {
      case 'top':
        position = LegendPosition.top;
      case 'left':
        position = LegendPosition.left;
      case 'right':
        position = LegendPosition.right;
      default:
        position = LegendPosition.bottom;
    }

    return Legend(
      isVisible: true,
      position: position,
      toggleSeriesVisibility: cfg.toggleVisibility,
      overflowMode: LegendItemOverflowMode.wrap,
    );
  }

  TooltipBehavior _buildTooltip() {
    final cfg = definition.tooltip;
    return TooltipBehavior(
      enable: cfg?.enabled ?? true,
      shared: cfg?.shared ?? false,
      format: cfg?.format,
    );
  }

  ChartAxis _buildXAxis() {
    final cfg = definition.xAxis;
    final axisType = cfg?.axisType ?? ChartAxisType.category;
    final title = cfg?.title != null
        ? AxisTitle(text: cfg!.title!)
        : const AxisTitle();
    final rotation = cfg?.labelRotation ?? 0;
    final visible = cfg?.visible ?? true;

    switch (axisType) {
      case ChartAxisType.numeric:
        return NumericAxis(
          title: title, labelRotation: rotation, isVisible: visible,
          minimum: cfg?.minimum, maximum: cfg?.maximum, interval: cfg?.interval,
        );
      case ChartAxisType.dateTime:
        return DateTimeAxis(
          title: title, labelRotation: rotation, isVisible: visible,
        );
      case ChartAxisType.dateTimeCategory:
        return DateTimeCategoryAxis(
          title: title, labelRotation: rotation, isVisible: visible,
        );
      case ChartAxisType.logarithmic:
        return LogarithmicAxis(
          title: title, labelRotation: rotation, isVisible: visible,
        );
      default:
        return CategoryAxis(
          title: title, labelRotation: rotation, isVisible: visible,
        );
    }
  }

  ChartAxis _buildYAxis() {
    final cfg = definition.yAxis;
    final title = cfg?.title != null
        ? AxisTitle(text: cfg!.title!)
        : const AxisTitle();
    return NumericAxis(
      title: title,
      minimum: cfg?.minimum,
      maximum: cfg?.maximum,
      interval: cfg?.interval,
      isVisible: cfg?.visible ?? true,
      labelFormat: cfg?.labelFormat,
    );
  }

  String _formatFieldName(String field) {
    return field
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
