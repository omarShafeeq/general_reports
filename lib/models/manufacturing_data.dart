class ManufacturingData {
  final DateTime date;
  final String productLine;
  final int unitsProduced;
  final int defects;
  final double efficiency;
  final double downtimeHours;
  final double cost;

  const ManufacturingData({
    required this.date,
    required this.productLine,
    required this.unitsProduced,
    required this.defects,
    required this.efficiency,
    required this.downtimeHours,
    required this.cost,
  });

  double get defectRate =>
      unitsProduced > 0 ? (defects / unitsProduced) * 100 : 0;

  double get costPerUnit =>
      unitsProduced > 0 ? cost / unitsProduced : 0;
}

class QualityData {
  final String defectType;
  final int count;
  final double percentage;
  final double cumulativePercentage;

  const QualityData({
    required this.defectType,
    required this.count,
    required this.percentage,
    required this.cumulativePercentage,
  });
}
