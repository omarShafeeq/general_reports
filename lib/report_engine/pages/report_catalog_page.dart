import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_sizes.dart';
import '../../routing/route_names.dart';
import '../../widgets/common/responsive_scaffold.dart';
import '../blocs/report_registry_cubit.dart';
import '../models/report_definition.dart';

class ReportCatalogPage extends StatelessWidget {
  const ReportCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Report Engine',
      currentRoute: RouteNames.reportCatalog,
      body: BlocBuilder<ReportRegistryCubit, Map<String, ReportDefinition>>(
        builder: (context, registry) {
          final cubit = context.read<ReportRegistryCubit>();
          final categories = cubit.categories;

          if (registry.isEmpty) {
            return const Center(
              child: Text('No reports registered'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final reports = cubit.byCategory(category);
              return _CategorySection(
                category: category,
                reports: reports,
              );
            },
          );
        },
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<ReportDefinition> reports;

  const _CategorySection({
    required this.category,
    required this.reports,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
          child: Text(
            category,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...reports.map((report) => _ReportCard(report: report)),
        const SizedBox(height: AppSizes.md),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final ReportDefinition report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: InkWell(
        onTap: () => context.goNamed(
          RouteNames.reportViewer,
          queryParameters: {'id': report.id},
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  report.icon,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (report.description.isNotEmpty)
                      Text(
                        report.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (report.filters.isNotEmpty)
                    _FeatureChip(
                      icon: Icons.filter_list,
                      label: '${report.filters.length} filters',
                    ),
                  if (report.charts.isNotEmpty)
                    _FeatureChip(
                      icon: Icons.bar_chart,
                      label: '${report.charts.length} charts',
                    ),
                  if (report.grids.isNotEmpty)
                    _FeatureChip(
                      icon: Icons.grid_on,
                      label: '${report.grids.length} grids',
                    ),
                ],
              ),
              const SizedBox(width: AppSizes.sm),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.xs),
      child: Chip(
        avatar: Icon(icon, size: 14),
        label: Text(label, style: const TextStyle(fontSize: 11)),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
