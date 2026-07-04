import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/charts/chart_wrapper.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

class ChartExportPage extends StatefulWidget {
  const ChartExportPage({super.key});

  @override
  State<ChartExportPage> createState() => _ChartExportPageState();
}

class _ChartExportPageState extends State<ChartExportPage> {
  final GlobalKey _chartKey = GlobalKey();
  Uint8List? _capturedImage;
  bool _isCapturing = false;

  final List<_ExportData> _data = const [
    _ExportData('Q1 2023', 42),
    _ExportData('Q2 2023', 55),
    _ExportData('Q3 2023', 48),
    _ExportData('Q4 2023', 62),
    _ExportData('Q1 2024', 50),
    _ExportData('Q2 2024', 68),
    _ExportData('Q3 2024', 58),
    _ExportData('Q4 2024', 74),
  ];

  Future<void> _captureChart() async {
    setState(() => _isCapturing = true);
    try {
      final boundary = _chartKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData != null) {
        setState(() {
          _capturedImage = byteData.buffer.asUint8List();
        });
      }
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ResponsiveScaffold(
      title: 'Chart Export',
      currentRoute: RouteNames.chartExport,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isCapturing ? null : _captureChart,
        icon: _isCapturing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.camera_alt),
        label: Text(_isCapturing ? 'Capturing...' : 'Capture Chart'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SizedBox(
            height: 380,
            child: ChartWrapper(
              title: 'Chart to Export',
              subtitle: 'Tap the capture button to generate an image',
              chart: RepaintBoundary(
                key: _chartKey,
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(
                    labelRotation: -45,
                  ),
                  primaryYAxis: const NumericAxis(
                    minimum: 0,
                    maximum: 80,
                    interval: 20,
                    labelFormat: '\${value}K',
                  ),
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<_ExportData, String>>[
                    ColumnSeries<_ExportData, String>(
                      name: 'Quarterly Revenue',
                      dataSource: _data,
                      xValueMapper: (d, _) => d.quarter,
                      yValueMapper: (d, _) => d.revenue,
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFF42A5F5), Color(0xFF0D47A1)],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_capturedImage != null) ...[
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Captured Image Preview',
                          style: theme.textTheme.titleMedium,
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _capturedImage = null),
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Clear'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _capturedImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_capturedImage!.length / 1024).toStringAsFixed(1)} KB  •  PNG format',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExportData {
  final String quarter;
  final double revenue;
  const _ExportData(this.quarter, this.revenue);
}
