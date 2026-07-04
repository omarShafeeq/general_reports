import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../report_engine/blocs/report_registry_cubit.dart';

/// Gathers live application state to enrich the AI system prompt.
///
/// Reads from existing cubits that are already provided in the widget tree.
class AppContextService {
  final BuildContext _context;

  const AppContextService(this._context);

  Map<String, dynamic> get currentContext {
    final result = <String, dynamic>{};

    try {
      final theme = _context.read<ThemeCubit>().state;
      result['language'] = theme.locale.languageCode;
      result['isRtl'] = theme.isRtl;
      result['isDarkMode'] = theme.isDark;
    } catch (_) {}

    try {
      final registry = _context.read<ReportRegistryCubit>().state;
      result['availableReports'] =
          registry.values.map((r) => r.title).toList();
    } catch (_) {}

    return result;
  }

  /// Adds transient context that changes per interaction (e.g. which screen
  /// the user is viewing, which report is selected).
  Map<String, dynamic> withScreenContext({
    String? currentScreen,
    String? selectedReport,
    Map<String, dynamic>? activeFilters,
    String? selectedCustomer,
    String? selectedCompany,
  }) {
    final base = currentContext;
    if (currentScreen != null) base['currentScreen'] = currentScreen;
    if (selectedReport != null) base['selectedReport'] = selectedReport;
    if (activeFilters != null) base['activeFilters'] = activeFilters;
    if (selectedCustomer != null) base['selectedCustomer'] = selectedCustomer;
    if (selectedCompany != null) base['selectedCompany'] = selectedCompany;
    return base;
  }
}
