import 'dart:math';
import 'package:general_reports/models/employee.dart';

abstract final class HrDataGenerator {
  static final _random = Random(44);

  static const _firstNames = [
    'James', 'Mary', 'Robert', 'Patricia', 'John', 'Jennifer', 'Michael', 'Linda',
    'David', 'Elizabeth', 'William', 'Barbara', 'Richard', 'Susan', 'Joseph', 'Jessica',
    'Thomas', 'Sarah', 'Charles', 'Karen', 'Christopher', 'Lisa', 'Daniel', 'Nancy',
    'Ahmed', 'Fatima', 'Wei', 'Yuki', 'Carlos', 'Maria', 'Hans', 'Olga',
  ];

  static const _lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
    'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Wilson', 'Anderson', 'Thomas', 'Taylor',
    'Chen', 'Tanaka', 'Mueller', 'Petrov', 'Kim', 'Singh', 'Okafor', 'Silva',
  ];

  static const _departments = ['Sales', 'Marketing', 'Engineering', 'HR', 'Finance', 'Operations', 'Support', 'Legal'];

  static const _designations = [
    'Junior Analyst', 'Analyst', 'Senior Analyst', 'Associate', 'Senior Associate',
    'Manager', 'Senior Manager', 'Director', 'VP', 'SVP',
  ];

  static const _cities = ['New York', 'London', 'Tokyo', 'Berlin', 'Sydney', 'Toronto', 'Mumbai', 'Sao Paulo', 'Dubai', 'Singapore'];
  static const _countries = ['USA', 'UK', 'Japan', 'Germany', 'Australia', 'Canada', 'India', 'Brazil', 'UAE', 'Singapore'];

  static List<Employee> generateEmployees({int count = 150}) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final cityIndex = _random.nextInt(_cities.length);
      return Employee(
        id: 1000 + i,
        firstName: _firstNames[_random.nextInt(_firstNames.length)],
        lastName: _lastNames[_random.nextInt(_lastNames.length)],
        email: 'emp${1000 + i}@company.com',
        department: _departments[_random.nextInt(_departments.length)],
        designation: _designations[_random.nextInt(_designations.length)],
        dateOfJoining: now.subtract(Duration(days: 90 + _random.nextInt(3000))),
        salary: 35000 + _random.nextDouble() * 165000,
        status: _random.nextDouble() > 0.1 ? 'Active' : 'Inactive',
        city: _cities[cityIndex],
        country: _countries[cityIndex],
        age: 22 + _random.nextInt(43),
        performanceScore: 1.0 + _random.nextDouble() * 4.0,
      );
    });
  }

  static List<AttendanceData> generateAttendance({int days = 30}) {
    final employees = generateEmployees(count: 50);
    final now = DateTime.now();
    final records = <AttendanceData>[];
    for (final emp in employees) {
      for (int d = 0; d < days; d++) {
        final date = now.subtract(Duration(days: days - d));
        if (date.weekday <= 5) {
          final isPresent = _random.nextDouble() > 0.08;
          records.add(AttendanceData(
            employeeId: emp.id,
            employeeName: emp.fullName,
            date: date,
            hoursWorked: isPresent ? 6 + _random.nextDouble() * 4 : 0,
            isPresent: isPresent,
            department: emp.department,
          ));
        }
      }
    }
    return records;
  }
}
