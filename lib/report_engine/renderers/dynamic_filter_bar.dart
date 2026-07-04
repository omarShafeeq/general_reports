import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/filter/report_filter_bloc.dart';
import '../blocs/filter/report_filter_event.dart';
import '../blocs/filter/report_filter_state.dart';
import '../models/enums.dart';
import '../models/filter_definition.dart';
import '../widgets/filters/boolean_filter_widget.dart';
import '../widgets/filters/date_filter_widget.dart';
import '../widgets/filters/date_range_filter_widget.dart';
import '../widgets/filters/dropdown_filter_widget.dart';
import '../widgets/filters/multi_select_filter_widget.dart';
import '../widgets/filters/period_filter_widget.dart';
import '../widgets/filters/searchable_dropdown_widget.dart';
import '../widgets/filters/tree_select_filter_widget.dart';

class DynamicFilterBar extends StatelessWidget {
  const DynamicFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportFilterBloc, ReportFilterState>(
      builder: (context, state) {
        if (state.definitions.isEmpty) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.all(AppSizes.sm),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reset'),
                      onPressed: () {
                        context
                            .read<ReportFilterBloc>()
                            .add(const ResetFilters());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Wrap(
                  spacing: AppSizes.md,
                  runSpacing: AppSizes.sm,
                  children: state.definitions.map((def) {
                    return _buildFilter(context, def, state);
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilter(
    BuildContext context,
    FilterDefinition def,
    ReportFilterState state,
  ) {
    final value = state.getValue(def.id);
    final options = state.getOptions(def.id);
    final isLoading = state.isLoading(def.id);

    void onChanged(dynamic newValue) {
      context.read<ReportFilterBloc>().add(
            FilterValueChanged(filterId: def.id, value: newValue),
          );
    }

    switch (def.type) {
      case ReportFilterType.date:
        return DateFilterWidget(
          definition: def,
          value: value as DateTime?,
          onChanged: onChanged,
        );

      case ReportFilterType.dateRange:
        return DateRangeFilterWidget(
          definition: def,
          value: value as DateTimeRange?,
          onChanged: onChanged,
        );

      case ReportFilterType.month:
      case ReportFilterType.quarter:
      case ReportFilterType.year:
        return PeriodFilterWidget(
          definition: def,
          value: value,
          onChanged: onChanged,
        );

      case ReportFilterType.boolean:
        return BooleanFilterWidget(
          definition: def,
          value: value as bool?,
          onChanged: onChanged,
        );

      case ReportFilterType.multiSelect:
        return MultiSelectFilterWidget(
          definition: def,
          selectedValues: value is List ? value.cast<String>() : [],
          options: options,
          isLoading: isLoading,
          onChanged: onChanged,
        );

      case ReportFilterType.searchableDropdown:
        return SearchableDropdownWidget(
          definition: def,
          value: value as String?,
          options: options,
          isLoading: isLoading,
          onChanged: onChanged,
        );

      case ReportFilterType.treeSelection:
        return TreeSelectFilterWidget(
          definition: def,
          value: value as String?,
          options: options,
          isLoading: isLoading,
          onChanged: onChanged,
        );

      case ReportFilterType.singleSelect:
      case ReportFilterType.company:
      case ReportFilterType.branch:
      case ReportFilterType.department:
      case ReportFilterType.customer:
      case ReportFilterType.employee:
      case ReportFilterType.product:
      case ReportFilterType.category:
      case ReportFilterType.status:
        return DropdownFilterWidget(
          definition: def,
          value: value as String?,
          options: options,
          isLoading: isLoading,
          onChanged: onChanged,
        );
    }
  }
}
