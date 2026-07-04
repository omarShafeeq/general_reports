import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/common/responsive_scaffold.dart';
import '../../routing/route_names.dart';
import '../blocs/data/report_data_bloc.dart';
import '../blocs/data/report_data_event.dart';
import '../blocs/drill_down_cubit.dart';
import '../blocs/export_cubit.dart';
import '../blocs/filter/report_filter_bloc.dart';
import '../blocs/filter/report_filter_event.dart';
import '../blocs/report_registry_cubit.dart';
import '../blocs/grid_view_settings_cubit.dart';
import '../blocs/report_viewer/report_viewer_bloc.dart';
import '../blocs/report_viewer/report_viewer_event.dart';
import '../blocs/report_viewer/report_viewer_state.dart';
import '../blocs/report_viewer_settings_cubit.dart';
import '../data/mock_report_repository.dart';
import '../data/report_repository.dart';
import '../models/drill_down_definition.dart';
import '../renderers/dynamic_report_page.dart';

class ReportViewerPage extends StatefulWidget {
  final String reportId;

  const ReportViewerPage({super.key, required this.reportId});

  @override
  State<ReportViewerPage> createState() => _ReportViewerPageState();
}

class _ReportViewerPageState extends State<ReportViewerPage> {
  late final ReportRepository _repository;
  late final ReportViewerBloc _viewerBloc;
  late final ReportFilterBloc _filterBloc;
  late final ReportDataBloc _dataBloc;
  late final DrillDownCubit _drillDownCubit;
  late final ExportCubit _exportCubit;
  late final ReportViewerSettingsCubit _settingsCubit;
  late final GridViewSettingsCubit _gridViewSettingsCubit;

  @override
  void initState() {
    super.initState();
    _repository = MockReportRepository();
    final registry = context.read<ReportRegistryCubit>();

    _viewerBloc = ReportViewerBloc(registry: registry);
    _filterBloc = ReportFilterBloc(repository: _repository);
    _dataBloc = ReportDataBloc(repository: _repository);
    _drillDownCubit = DrillDownCubit();
    _exportCubit = ExportCubit();
    _settingsCubit = ReportViewerSettingsCubit();
    _gridViewSettingsCubit = GridViewSettingsCubit();

    _viewerBloc.add(LoadReport(reportId: widget.reportId));
  }

  @override
  void dispose() {
    _viewerBloc.close();
    _filterBloc.close();
    _dataBloc.close();
    _drillDownCubit.close();
    _exportCubit.close();
    _settingsCubit.close();
    _gridViewSettingsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _viewerBloc),
        BlocProvider.value(value: _filterBloc),
        BlocProvider.value(value: _dataBloc),
        BlocProvider.value(value: _drillDownCubit),
        BlocProvider.value(value: _exportCubit),
        BlocProvider.value(value: _settingsCubit),
        BlocProvider.value(value: _gridViewSettingsCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          // When report is loaded, initialize filters and fetch initial data
          BlocListener<ReportViewerBloc, ReportViewerState>(
            listener: (context, state) {
              if (state.status == ReportViewerStatus.loaded &&
                  state.report != null) {
                final report = state.report!;
                _filterBloc.add(InitializeFilters(report.filters));
                _gridViewSettingsCubit.initFromReport(report);
                _dataBloc.add(FetchReportData(datasource: report.datasource));
              }
            },
          ),
          // When drill-down changes, load the target report
          BlocListener<DrillDownCubit, List<DrillDownLevel>>(
            listener: (context, stack) {
              if (stack.isNotEmpty) {
                final level = stack.last;
                _viewerBloc.add(LoadReport(
                  reportId: level.reportId,
                  initialParams: {level.paramKey: level.paramValue},
                ));
              } else {
                _viewerBloc.add(LoadReport(reportId: widget.reportId));
              }
            },
          ),
          // When viewer loads a new report after drill-down, refresh data
          BlocListener<ReportViewerBloc, ReportViewerState>(
            listenWhen: (prev, curr) =>
                prev.report?.id != curr.report?.id &&
                curr.status == ReportViewerStatus.loaded,
            listener: (context, state) {
              if (state.report != null) {
                final report = state.report!;
                _filterBloc.add(InitializeFilters(report.filters));
                _gridViewSettingsCubit.initFromReport(report);

                final params = <String, dynamic>{};
                final currentLevel = _drillDownCubit.current;
                if (currentLevel != null) {
                  params[currentLevel.paramKey] = currentLevel.paramValue;
                }
                _dataBloc.add(FetchReportData(
                  datasource: report.datasource,
                  params: params,
                ));
              }
            },
          ),
        ],
        child: BlocBuilder<ReportViewerBloc, ReportViewerState>(
          builder: (context, viewerState) {
            final title = viewerState.report?.title ?? 'Report';

            return ResponsiveScaffold(
              title: title,
              currentRoute: RouteNames.reportCatalog,
              body: _buildBody(viewerState),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(ReportViewerState viewerState) {
    if (viewerState.status == ReportViewerStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewerState.status == ReportViewerStatus.error) {
      return Center(
        child: Text(
          viewerState.errorMessage ?? 'Error loading report',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    if (viewerState.report == null) {
      return const Center(child: Text('No report selected'));
    }

    return DynamicReportPage(
      report: viewerState.report!,
      repository: _repository,
    );
  }
}
