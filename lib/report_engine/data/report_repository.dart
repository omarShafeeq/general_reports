import '../models/filter_definition.dart';

abstract class ReportRepository {
  Future<Map<String, dynamic>> fetchReportData(
    String datasource,
    Map<String, dynamic> params,
  );

  Future<List<FilterOption>> fetchFilterOptions(
    String endpoint,
    Map<String, dynamic> parentParams,
  );

  Future<List<Map<String, dynamic>>> fetchChildData({
    required String childDatasource,
    required String parentKeyField,
    required dynamic parentKeyValue,
    Map<String, dynamic> params = const {},
  });
}
