import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final List<String> data;
  final int selectedIndex;
  final FixedExtentScrollController scrollController;
  final ValueChanged<int> onSelectedItemChanged;

  CustomPicker({
    Key key,
    this.data,
    this.selectedIndex,
    this.scrollController,
    this.onSelectedItemChanged,
  }) : super(key: key);

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ?? FixedExtentScrollController(initialItem: widget.selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      itemExtent: 44,
      scrollController: _scrollController,
      onSelectedItemChanged: widget.onSelectedItemChanged,
      useMagnifier: true,
      magnification: 1.1,
      selectionOverlay: Container(color: Color(0x60B0D2FB)),
      itemBuilder: (ctx, index) {
        if (index < 0) {
          return null;
        }
        if (index >= widget.data.length) {
          return null;
        }
        String desc = widget.data[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(
              desc ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: widget.selectedIndex == index ? Color(0xFF1030FF) : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}
