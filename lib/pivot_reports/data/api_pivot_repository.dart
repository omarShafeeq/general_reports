import '../models/models.dart';
import 'pivot_repository.dart';

class ApiPivotRepository implements PivotRepository {
  // TODO: inject Dio or http.Client for real API calls
  // final Dio _dio;
  // ApiPivotRepository({required Dio dio}) : _dio = dio;

  @override
  Future<List<PivotDataSource>> fetchDataSources() {
    // GET /pivot/datasources
    throw UnimplementedError('Connect to GET /pivot/datasources');
  }

  @override
  Future<List<PivotField>> fetchFields(String dataSourceId) {
    // GET /pivot/fields/{dataSourceId}
    throw UnimplementedError('Connect to GET /pivot/fields/$dataSourceId');
  }

  @override
  Future<PivotResult> executeReport(PivotLayout layout) {
    // POST /pivot/report  body: layout.toRequestJson()
    throw UnimplementedError('Connect to POST /pivot/report');
  }

  @override
  Future<PivotReport> saveReport(PivotReport report) {
    // POST /pivot/save  body: report.toJson()
    throw UnimplementedError('Connect to POST /pivot/save');
  }

  @override
  Future<List<PivotReport>> fetchSavedReports() {
    // GET /pivot/savedReports
    throw UnimplementedError('Connect to GET /pivot/savedReports');
  }

  @override
  Future<void> deleteReport(String reportId) {
    // DELETE /pivot/report/{reportId}
    throw UnimplementedError('Connect to DELETE /pivot/report/$reportId');
  }

  @override
  Future<PivotReport> duplicateReport(String reportId, String newName) {
    throw UnimplementedError('Connect to POST /pivot/report/$reportId/duplicate');
  }
}
