import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/report_engine/blocs/grid_view_settings_cubit.dart';
import 'package:general_reports/report_engine/config/reports/sales_overview_config.dart';
import 'package:general_reports/report_engine/data/mock_report_repository.dart';
import 'package:general_reports/report_engine/models/report_definition.dart';
import 'package:general_reports/report_engine/renderers/dynamic_grid_renderer.dart';
import 'package:general_reports/routing/route_names.dart';
import 'package:general_reports/widgets/common/responsive_scaffold.dart';

/// Demonstrates runtime column visibility and selectable sum columns —
/// same grid options used in the Sales Overview report engine section.
class GridOptionsPage extends StatefulWidget {
  const GridOptionsPage({super.key});

  @override
  State<GridOptionsPage> createState() => _GridOptionsPageState();
}

class _GridOptionsPageState extends State<GridOptionsPage> {
  static final _gridDefinition = salesOverviewReport.grids
      .firstWhere((g) => g.id == 'order-details');

  late final GridViewSettingsCubit _gridSettingsCubit;
  late final MockReportRepository _repository;

  List<Map<String, dynamic>> _data = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _gridSettingsCubit = GridViewSettingsCubit();
    _repository = MockReportRepository();
    _loadData();
  }

  @override
  void dispose() {
    _gridSettingsCubit.close();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _repository.fetchReportData('sales-overview', {});
      final orderDetails = result['orderDetails'];
      final items = orderDetails is List
          ? orderDetails.cast<Map<String, dynamic>>()
          : <Map<String, dynamic>>[];

      _gridSettingsCubit.initFromReport(
        ReportDefinition(
          id: 'grid-options-demo',
          title: 'Grid Options Demo',
          datasource: 'sales-overview',
          grids: [_gridDefinition],
        ),
      );

      if (!mounted) return;
      setState(() {
        _data = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      title: 'Grid Options',
      currentRoute: RouteNames.gridOptionsGrid,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md, AppSizes.sm, AppSizes.md, 0,
            ),
            child: Text(
              'Sales Overview order grid with runtime column picker and '
              'selectable sum columns. Use the toolbar above the grid to '
              'show/hide columns and choose which numeric fields are totaled.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: _buildBody(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
      );
    }

    return BlocProvider.value(
      value: _gridSettingsCubit,
      child: DynamicGridRenderer(
        definition: _gridDefinition,
        data: _data,
      ),
    );
  }
}
