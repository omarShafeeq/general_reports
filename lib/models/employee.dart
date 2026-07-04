class Employee {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String department;
  final String designation;
  final DateTime dateOfJoining;
  final double salary;
  final String status;
  final String city;
  final String country;
  final int age;
  final double performanceScore;

  const Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
    required this.designation,
    required this.dateOfJoining,
    required this.salary,
    required this.status,
    required this.city,
    required this.country,
    required this.age,
    required this.performanceScore,
  });

  String get fullName => '$firstName $lastName';
  int get yearsOfService => DateTime.now().difference(dateOfJoining).inDays ~/ 365;
}

class AttendanceData {
  final int employeeId;
  final String employeeName;
  final DateTime date;
  final double hoursWorked;
  final bool isPresent;
  final String department;

  const AttendanceData({
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.hoursWorked,
    required this.isPresent,
    required this.department,
  });
}
