import 'dart:math';
import 'package:general_reports/models/project_data.dart';

abstract final class ProjectDataGenerator {
  static final _random = Random(49);

  static const _projectNames = [
    'Mobile App Redesign', 'Cloud Migration', 'CRM Implementation', 'Data Warehouse',
    'ERP Upgrade', 'Website Revamp', 'Security Audit', 'AI Integration',
    'DevOps Pipeline', 'Customer Portal', 'Analytics Dashboard', 'Inventory System',
  ];
  static const _managers = ['Alice Brown', 'Bob Smith', 'Carol Davis', 'Dan Wilson', 'Eve Johnson', 'Frank Lee'];
  static const _departments = ['Engineering', 'IT', 'Marketing', 'Operations', 'R&D', 'Sales'];
  static const _statuses = ['Not Started', 'In Progress', 'On Hold', 'Completed', 'Cancelled'];
  static const _priorities = ['Low', 'Medium', 'High', 'Critical'];

  static List<ProjectData> generateProjects({int count = 20}) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final start = now.subtract(Duration(days: _random.nextInt(300)));
      final duration = 30 + _random.nextInt(270);
      final end = start.add(Duration(days: duration));
      final budget = 50000 + _random.nextDouble() * 450000;
      final progress = _random.nextDouble() * 100;
      return ProjectData(
        id: 7000 + i,
        name: _projectNames[i % _projectNames.length],
        manager: _managers[_random.nextInt(_managers.length)],
        department: _departments[_random.nextInt(_departments.length)],
        startDate: start,
        endDate: end,
        budget: budget,
        spent: budget * (_random.nextDouble() * 1.1),
        progress: progress,
        status: _statuses[_random.nextInt(_statuses.length)],
        teamSize: 3 + _random.nextInt(22),
        priority: _priorities[_random.nextInt(_priorities.length)],
      );
    });
  }
}
