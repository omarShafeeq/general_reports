import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/drill_down_cubit.dart';
import '../models/drill_down_definition.dart';

class DrillDownBreadcrumb extends StatelessWidget {
  const DrillDownBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrillDownCubit, List<DrillDownLevel>>(
      builder: (context, stack) {
        if (stack.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => context.read<DrillDownCubit>().reset(),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Root',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...stack.asMap().entries.map((entry) {
                final index = entry.key;
                final level = entry.value;
                final isLast = index == stack.length - 1;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    InkWell(
                      onTap: isLast
                          ? null
                          : () =>
                              context.read<DrillDownCubit>().popTo(index),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusSm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        child: Text(
                          level.breadcrumbLabel,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isLast
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                : Theme.of(context).colorScheme.primary,
                            fontWeight:
                                isLast ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
