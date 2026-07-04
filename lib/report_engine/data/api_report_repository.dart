import '../models/filter_definition.dart';
import 'report_repository.dart';

/// HTTP-based implementation of [ReportRepository].
/// Replace the placeholder logic with actual HTTP calls (Dio, http, etc.)
/// when connecting to a real backend.
class ApiReportRepository implements ReportRepository {
  final String baseUrl;

  const ApiReportRepository({required this.baseUrl});

  @override
  Future<Map<String, dynamic>> fetchReportData(
    String datasource,
    Map<String, dynamic> params,
  ) async {
    // TODO: Replace with real HTTP call
    // final response = await dio.get('$baseUrl/$datasource', queryParameters: params);
    // return response.data as Map<String, dynamic>;
    throw UnimplementedError(
      'ApiReportRepository.fetchReportData not yet connected to a backend. '
      'Use MockReportRepository for development.',
    );
  }

  @override
  Future<List<FilterOption>> fetchFilterOptions(
    String endpoint,
    Map<String, dynamic> parentParams,
  ) async {
    // TODO: Replace with real HTTP call
    throw UnimplementedError(
      'ApiReportRepository.fetchFilterOptions not yet connected to a backend. '
      'Use MockReportRepository for development.',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchChildData({
    required String childDatasource,
    required String parentKeyField,
    required dynamic parentKeyValue,
    Map<String, dynamic> params = const {},
  }) async {
    // TODO: Replace with real HTTP call
    throw UnimplementedError(
      'ApiReportRepository.fetchChildData not yet connected to a backend. '
      'Use MockReportRepository for development.',
    );
  }
}
