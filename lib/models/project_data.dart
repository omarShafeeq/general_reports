class ProjectData {
  final int id;
  final String name;
  final String manager;
  final String department;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final double spent;
  final double progress;
  final String status;
  final int teamSize;
  final String priority;

  const ProjectData({
    required this.id,
    required this.name,
    required this.manager,
    required this.department,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.spent,
    required this.progress,
    required this.status,
    required this.teamSize,
    required this.priority,
  });

  double get budgetUtilization => budget > 0 ? (spent / budget) * 100 : 0;
  int get durationDays => endDate.difference(startDate).inDays;
  int get remainingDays {
    final now = DateTime.now();
    return now.isBefore(endDate) ? endDate.difference(now).inDays : 0;
  }
}
