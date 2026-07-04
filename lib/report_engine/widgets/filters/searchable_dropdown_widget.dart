import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../models/filter_definition.dart';

class SearchableDropdownWidget extends StatefulWidget {
  final FilterDefinition definition;
  final String? value;
  final List<FilterOption> options;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  const SearchableDropdownWidget({
    super.key,
    required this.definition,
    required this.value,
    required this.options,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  State<SearchableDropdownWidget> createState() =>
      _SearchableDropdownWidgetState();
}

class _SearchableDropdownWidgetState extends State<SearchableDropdownWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<FilterOption> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.options;
    if (widget.value != null) {
      final match = widget.options.where((o) => o.value == widget.value).firstOrNull;
      if (match != null) _controller.text = match.label;
    }
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SearchableDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options != widget.options) {
      _filtered = widget.options;
    }
    if (oldWidget.value != widget.value && widget.value != null) {
      final match = widget.options.where((o) => o.value == widget.value).firstOrNull;
      if (match != null) _controller.text = match.label;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final opt = _filtered[index];
                    return ListTile(
                      dense: true,
                      title: Text(opt.label),
                      selected: opt.value == widget.value,
                      onTap: () {
                        _controller.text = opt.label;
                        widget.onChanged(opt.value);
                        _focusNode.unfocus();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: widget.definition.label,
            isDense: true,
            suffixIcon: widget.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : widget.value != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _controller.clear();
                          widget.onChanged(null);
                        },
                      )
                    : const Icon(Icons.search, size: 18),
          ),
          onChanged: (text) {
            setState(() {
              _filtered = widget.options
                  .where((o) =>
                      o.label.toLowerCase().contains(text.toLowerCase()))
                  .toList();
            });
            if (_overlayEntry != null) {
              _overlayEntry!.markNeedsBuild();
            }
          },
        ),
      ),
    );
  }
}
