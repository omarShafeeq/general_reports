import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'drill_down_definition.dart';
import 'enums.dart';

class ChartDefinition extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final ReportChartType chartType;
  final String dataKey;
  final String xField;
  final List<String> yFields;
  final String? groupBy;
  final String? aggregation;
  final List<Color>? palette;
  final ChartLegendConfig? legend;
  final ChartTooltipConfig? tooltip;
  final ChartAxisConfig? xAxis;
  final ChartAxisConfig? yAxis;
  final List<ChartAnnotationConfig>? annotations;
  final ChartTrackballConfig? trackball;
  final ChartCrosshairConfig? crosshair;
  final ChartZoomConfig? zoomPan;
  final ChartSelectionConfig? selection;
  final ChartDataLabelConfig? dataLabels;
  final bool enableAnimation;
  final int animationDuration;
  final DrillDownDefinition? drillDown;
  final Map<String, dynamic>? options;

  const ChartDefinition({
    required this.id,
    required this.title,
    this.subtitle,
    required this.chartType,
    required this.dataKey,
    required this.xField,
    required this.yFields,
    this.groupBy,
    this.aggregation,
    this.palette,
    this.legend,
    this.tooltip,
    this.xAxis,
    this.yAxis,
    this.annotations,
    this.trackball,
    this.crosshair,
    this.zoomPan,
    this.selection,
    this.dataLabels,
    this.enableAnimation = true,
    this.animationDuration = 1500,
    this.drillDown,
    this.options,
  });

  bool get isCircular =>
      chartType == ReportChartType.pie ||
      chartType == ReportChartType.doughnut ||
      chartType == ReportChartType.radialBar;

  bool get isFunnel =>
      chartType == ReportChartType.funnel ||
      chartType == ReportChartType.pyramid;

  @override
  List<Object?> get props => [
        id, title, subtitle, chartType, dataKey, xField, yFields,
        groupBy, aggregation, palette, legend, tooltip, xAxis, yAxis,
        annotations, trackball, crosshair, zoomPan, selection, dataLabels,
        enableAnimation, animationDuration, drillDown, options,
      ];
}

class ChartLegendConfig extends Equatable {
  final bool visible;
  final String position; // top, bottom, left, right
  final bool toggleVisibility;

  const ChartLegendConfig({
    this.visible = true,
    this.position = 'bottom',
    this.toggleVisibility = true,
  });

  @override
  List<Object?> get props => [visible, position, toggleVisibility];
}

class ChartTooltipConfig extends Equatable {
  final bool enabled;
  final String? format;
  final bool shared;

  const ChartTooltipConfig({
    this.enabled = true,
    this.format,
    this.shared = false,
  });

  @override
  List<Object?> get props => [enabled, format, shared];
}

class ChartAxisConfig extends Equatable {
  final String? title;
  final ChartAxisType axisType;
  final String? labelFormat;
  final int? labelRotation;
  final double? minimum;
  final double? maximum;
  final double? interval;
  final bool visible;

  const ChartAxisConfig({
    this.title,
    this.axisType = ChartAxisType.category,
    this.labelFormat,
    this.labelRotation,
    this.minimum,
    this.maximum,
    this.interval,
    this.visible = true,
  });

  @override
  List<Object?> get props =>
      [title, axisType, labelFormat, labelRotation, minimum, maximum, interval, visible];
}

class ChartAnnotationConfig extends Equatable {
  final String text;
  final dynamic x;
  final dynamic y;
  final Color? color;

  const ChartAnnotationConfig({
    required this.text,
    this.x,
    this.y,
    this.color,
  });

  @override
  List<Object?> get props => [text, x, y, color];
}

class ChartTrackballConfig extends Equatable {
  final bool enabled;
  final String activationMode; // longPress, singleTap, doubleTap, none
  final bool hideDelay;
  final String tooltipDisplayMode; // floatAllPoints, groupAllPoints, nearestPoint

  const ChartTrackballConfig({
    this.enabled = true,
    this.activationMode = 'singleTap',
    this.hideDelay = true,
    this.tooltipDisplayMode = 'groupAllPoints',
  });

  @override
  List<Object?> get props => [enabled, activationMode, hideDelay, tooltipDisplayMode];
}

class ChartCrosshairConfig extends Equatable {
  final bool enabled;
  final String activationMode;
  final bool showXLine;
  final bool showYLine;

  const ChartCrosshairConfig({
    this.enabled = true,
    this.activationMode = 'longPress',
    this.showXLine = true,
    this.showYLine = true,
  });

  @override
  List<Object?> get props => [enabled, activationMode, showXLine, showYLine];
}

class ChartZoomConfig extends Equatable {
  final bool enablePinching;
  final bool enableDoubleTapZooming;
  final bool enablePanning;
  final bool enableSelectionZooming;
  final bool enableMouseWheelZooming;
  final String zoomMode; // x, y, xy

  const ChartZoomConfig({
    this.enablePinching = true,
    this.enableDoubleTapZooming = true,
    this.enablePanning = true,
    this.enableSelectionZooming = false,
    this.enableMouseWheelZooming = true,
    this.zoomMode = 'xy',
  });

  @override
  List<Object?> get props => [
        enablePinching, enableDoubleTapZooming, enablePanning,
        enableSelectionZooming, enableMouseWheelZooming, zoomMode,
      ];
}

class ChartSelectionConfig extends Equatable {
  final bool enabled;
  final bool enableMultiSelection;
  final String selectionType; // point, series, cluster

  const ChartSelectionConfig({
    this.enabled = true,
    this.enableMultiSelection = false,
    this.selectionType = 'point',
  });

  @override
  List<Object?> get props => [enabled, enableMultiSelection, selectionType];
}

class ChartDataLabelConfig extends Equatable {
  final bool visible;
  final String position; // auto, outer, inside, outside
  final String? format;
  final bool showValue;
  final bool showPercentage;

  const ChartDataLabelConfig({
    this.visible = true,
    this.position = 'auto',
    this.format,
    this.showValue = true,
    this.showPercentage = false,
  });

  @override
  List<Object?> get props => [visible, position, format, showValue, showPercentage];
}
