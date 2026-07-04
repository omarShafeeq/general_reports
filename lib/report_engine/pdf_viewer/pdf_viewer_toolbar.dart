import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../core/constants/app_sizes.dart';
import '../blocs/pdf_viewer_cubit.dart';

class PdfViewerToolbar extends StatelessWidget {
  final PdfViewerController pdfController;
  final GlobalKey<SfPdfViewerState> pdfViewerKey;

  const PdfViewerToolbar({
    super.key,
    required this.pdfController,
    required this.pdfViewerKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PdfViewerCubit, PdfViewerState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              _buildIconButton(
                icon: Icons.chevron_left,
                tooltip: 'Previous Page',
                onPressed: state.currentPage > 1
                    ? () => pdfController.previousPage()
                    : null,
              ),
              SizedBox(
                width: 64,
                child: Center(
                  child: Text(
                    '${state.currentPage} / ${state.totalPages}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              _buildIconButton(
                icon: Icons.chevron_right,
                tooltip: 'Next Page',
                onPressed: state.currentPage < state.totalPages
                    ? () => pdfController.nextPage()
                    : null,
              ),
              _buildDivider(),
              _buildIconButton(
                icon: Icons.zoom_out,
                tooltip: 'Zoom Out',
                onPressed: () {
                  final newZoom = (pdfController.zoomLevel - 0.25)
                      .clamp(0.5, 5.0);
                  pdfController.zoomLevel = newZoom;
                  context.read<PdfViewerCubit>().setZoom(newZoom);
                },
              ),
              SizedBox(
                width: 52,
                child: Center(
                  child: Text(
                    '${(state.zoomLevel * 100).round()}%',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              _buildIconButton(
                icon: Icons.zoom_in,
                tooltip: 'Zoom In',
                onPressed: () {
                  final newZoom = (pdfController.zoomLevel + 0.25)
                      .clamp(0.5, 5.0);
                  pdfController.zoomLevel = newZoom;
                  context.read<PdfViewerCubit>().setZoom(newZoom);
                },
              ),
              _buildDivider(),
              _buildIconButton(
                icon: Icons.search,
                tooltip: 'Search',
                onPressed: () {
                  pdfViewerKey.currentState?.openBookmarkView();
                },
              ),
              const Spacer(),
              _buildIconButton(
                icon: Icons.bookmark_outline,
                tooltip: 'Bookmarks',
                onPressed: () {
                  pdfViewerKey.currentState?.openBookmarkView();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        icon: Icon(icon, size: 18),
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 24,
        child: VerticalDivider(width: 1, thickness: 1),
      ),
    );
  }
}
