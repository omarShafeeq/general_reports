import 'dart:math';
import 'package:general_reports/models/healthcare_data.dart';

abstract final class HealthcareDataGenerator {
  static final _random = Random(46);

  static const _departments = ['Cardiology', 'Neurology', 'Orthopedics', 'Pediatrics', 'Emergency', 'Oncology', 'General Medicine'];
  static const _diagnoses = ['Heart Disease', 'Stroke', 'Fracture', 'Pneumonia', 'Diabetes', 'Cancer', 'Infection', 'Asthma'];
  static const _doctors = ['Dr. Smith', 'Dr. Johnson', 'Dr. Williams', 'Dr. Brown', 'Dr. Davis', 'Dr. Chen', 'Dr. Patel', 'Dr. Kim'];
  static const _names = ['Alice Cooper', 'Bob Martin', 'Carol White', 'Dan Harris', 'Eve Clark', 'Frank Lewis', 'Grace Hall', 'Henry Young'];

  static List<HealthcareRecord> generateRecords({int count = 120}) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final admission = now.subtract(Duration(days: _random.nextInt(90)));
      final isDischarged = _random.nextDouble() > 0.3;
      return HealthcareRecord(
        patientId: 3000 + i,
        patientName: _names[_random.nextInt(_names.length)],
        age: 5 + _random.nextInt(85),
        gender: _random.nextBool() ? 'Male' : 'Female',
        department: _departments[_random.nextInt(_departments.length)],
        diagnosis: _diagnoses[_random.nextInt(_diagnoses.length)],
        admissionDate: admission,
        dischargeDate: isDischarged ? admission.add(Duration(days: 1 + _random.nextInt(14))) : null,
        billAmount: 1000 + _random.nextDouble() * 49000,
        status: isDischarged ? 'Discharged' : 'Admitted',
        doctorName: _doctors[_random.nextInt(_doctors.length)],
      );
    });
  }

  static List<DepartmentStats> generateDeptStats() {
    return _departments.map((dept) {
      final total = 50 + _random.nextInt(200);
      final discharged = (total * (0.5 + _random.nextDouble() * 0.4)).round();
      return DepartmentStats(
        department: dept,
        totalPatients: total,
        admitted: total - discharged,
        discharged: discharged,
        avgStayDays: 2 + _random.nextDouble() * 12,
        revenue: 100000 + _random.nextDouble() * 900000,
      );
    }).toList();
  }
}
