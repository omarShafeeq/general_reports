/// Generic chart data point for simple x/y charts.
class ChartSampleData {
  final dynamic x;
  final num? y;
  final num? y2;
  final num? y3;
  final num? y4;
  final num? size;
  final String? text;

  const ChartSampleData({
    this.x,
    this.y,
    this.y2,
    this.y3,
    this.y4,
    this.size,
    this.text,
  });
}

/// Data point for box-and-whisker charts.
class BoxPlotData {
  final String category;
  final List<num> values;

  const BoxPlotData({required this.category, required this.values});
}
