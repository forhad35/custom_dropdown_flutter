import 'package:flutter/material.dart';


class CustomStackDropdown extends StatefulWidget {
  final List<DropdownModel> items;
  final DropdownModel? selectedItem;
  final ValueChanged<DropdownModel> onChanged;
  final String? hint;
  final double? width;
  final double? height;
  final BoxDecoration? buttonDecoration;
  final BoxDecoration? menuDecoration;

  const CustomStackDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.hint,
    this.width,
    this.height,
    this.buttonDecoration,
    this.menuDecoration,
  });

  @override
  State<CustomStackDropdown> createState() => _CustomStackDropdownState();
}

class _CustomStackDropdownState extends State<CustomStackDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: widget.width ?? size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: widget.menuDecoration ??
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(blurRadius: 8, color: Colors.black12)
                    ],
                  ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: widget.items.map((item) {
                  return ListTile(
                    title: Text(item.title ?? ''),
                    onTap: () {
                      widget.onChanged(item);
                      _removeDropdown();
                    },
                    selected: widget.selectedItem?.value == item.value,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          width: widget.width,
          height: widget.height ?? 48,
          decoration: widget.buttonDecoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.selectedItem?.title ?? widget.hint ?? 'Select',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(_isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
