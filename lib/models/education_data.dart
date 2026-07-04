class StudentData {
  final int id;
  final String name;
  final String grade;
  final String department;
  final double gpa;
  final double attendance;
  final String status;
  final int enrollmentYear;

  const StudentData({
    required this.id,
    required this.name,
    required this.grade,
    required this.department,
    required this.gpa,
    required this.attendance,
    required this.status,
    required this.enrollmentYear,
  });
}

class CoursePerformance {
  final String course;
  final int enrolled;
  final double avgScore;
  final double passRate;
  final String department;

  const CoursePerformance({
    required this.course,
    required this.enrolled,
    required this.avgScore,
    required this.passRate,
    required this.department,
  });
}
