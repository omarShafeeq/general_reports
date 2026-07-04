import '../models/models.dart';

abstract class PivotRepository {
  Future<List<PivotDataSource>> fetchDataSources();

  Future<List<PivotField>> fetchFields(String dataSourceId);

  Future<PivotResult> executeReport(PivotLayout layout);

  Future<PivotReport> saveReport(PivotReport report);

  Future<List<PivotReport>> fetchSavedReports();

  Future<void> deleteReport(String reportId);

  Future<PivotReport> duplicateReport(String reportId, String newName);
}
