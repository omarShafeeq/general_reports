class HealthcareRecord {
  final int patientId;
  final String patientName;
  final int age;
  final String gender;
  final String department;
  final String diagnosis;
  final DateTime admissionDate;
  final DateTime? dischargeDate;
  final double billAmount;
  final String status;
  final String doctorName;

  const HealthcareRecord({
    required this.patientId,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.department,
    required this.diagnosis,
    required this.admissionDate,
    this.dischargeDate,
    required this.billAmount,
    required this.status,
    required this.doctorName,
  });

  int get stayDays {
    final end = dischargeDate ?? DateTime.now();
    return end.difference(admissionDate).inDays;
  }
}

class DepartmentStats {
  final String department;
  final int totalPatients;
  final int admitted;
  final int discharged;
  final double avgStayDays;
  final double revenue;

  const DepartmentStats({
    required this.department,
    required this.totalPatients,
    required this.admitted,
    required this.discharged,
    required this.avgStayDays,
    required this.revenue,
  });
}
