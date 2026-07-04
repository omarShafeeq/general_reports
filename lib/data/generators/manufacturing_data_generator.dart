import 'dart:math';
import 'package:general_reports/models/manufacturing_data.dart';

abstract final class ManufacturingDataGenerator {
  static final _random = Random(47);

  static const _productLines = ['Assembly A', 'Assembly B', 'Packaging', 'Welding', 'Finishing', 'Quality Check'];
  static const _defectTypes = [
    'Surface Scratch', 'Dimension Error', 'Color Mismatch', 'Missing Part',
    'Weak Weld', 'Alignment Issue', 'Material Defect', 'Packaging Damage',
  ];

  static List<ManufacturingData> generateDaily({int days = 90}) {
    final now = DateTime.now();
    return List.generate(days * _productLines.length, (i) {
      final dayIndex = i ~/ _productLines.length;
      final lineIndex = i % _productLines.length;
      final date = now.subtract(Duration(days: days - dayIndex));
      final units = 500 + _random.nextInt(1500);
      return ManufacturingData(
        date: date,
        productLine: _productLines[lineIndex],
        unitsProduced: units,
        defects: _random.nextInt((units * 0.05).round() + 1),
        efficiency: 75 + _random.nextDouble() * 25,
        downtimeHours: _random.nextDouble() * 4,
        cost: units * (2 + _random.nextDouble() * 3),
      );
    });
  }

  static List<QualityData> generateParetoData() {
    final counts = _defectTypes.map((_) => 5 + _random.nextInt(95)).toList();
    counts.sort((a, b) => b.compareTo(a));
    final total = counts.reduce((a, b) => a + b);
    double cumulative = 0;
    return List.generate(_defectTypes.length, (i) {
      final pct = (counts[i] / total) * 100;
      cumulative += pct;
      return QualityData(
        defectType: _defectTypes[i],
        count: counts[i],
        percentage: pct,
        cumulativePercentage: cumulative,
      );
    });
  }
}
