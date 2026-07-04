import 'dart:math';
import 'package:general_reports/models/education_data.dart';

abstract final class EducationDataGenerator {
  static final _random = Random(48);

  static const _departments = ['Computer Science', 'Mathematics', 'Physics', 'Business', 'Engineering', 'Arts', 'Medicine'];
  static const _courses = [
    'Data Structures', 'Algorithms', 'Machine Learning', 'Statistics',
    'Quantum Physics', 'Marketing 101', 'Financial Accounting', 'Digital Design',
    'Organic Chemistry', 'World History', 'Creative Writing', 'Calculus III',
  ];
  static const _names = [
    'Alex Turner', 'Beth Cooper', 'Chris Martin', 'Diana Ross', 'Eric Schmidt',
    'Fiona Green', 'George Harris', 'Helen Clark', 'Ivan Petrov', 'Julia Chen',
  ];
  static const _grades = ['A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D', 'F'];

  static List<StudentData> generateStudents({int count = 200}) {
    return List.generate(count, (i) {
      return StudentData(
        id: 2000 + i,
        name: _names[_random.nextInt(_names.length)],
        grade: _grades[_random.nextInt(_grades.length)],
        department: _departments[_random.nextInt(_departments.length)],
        gpa: 1.0 + _random.nextDouble() * 3.0,
        attendance: 60 + _random.nextDouble() * 40,
        status: _random.nextDouble() > 0.05 ? 'Active' : 'Withdrawn',
        enrollmentYear: 2022 + _random.nextInt(4),
      );
    });
  }

  static List<CoursePerformance> generateCoursePerformance() {
    return _courses.map((course) {
      return CoursePerformance(
        course: course,
        enrolled: 30 + _random.nextInt(170),
        avgScore: 50 + _random.nextDouble() * 45,
        passRate: 60 + _random.nextDouble() * 38,
        department: _departments[_random.nextInt(_departments.length)],
      );
    }).toList();
  }
}
