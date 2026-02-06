import 'package:flutter/material.dart';

class LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection textDirection;
  final StackFit sizing;

  const LazyIndexedStack({
    Key key,
    @required this.index,
    @required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
  }) : super(key: key);

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  List<bool> _loadedIndices;

  @override
  void initState() {
    super.initState();
    _loadedIndices = List.filled(widget.children.length, false);
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _loadedIndices = List.filled(widget.children.length, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadedIndices[widget.index] = true;

    return IndexedStack(
      index: widget.index,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      children: _loadedIndices
          .asMap()
          .map((index, isLoaded) => MapEntry(index, isLoaded ? widget.children[index] : Container()))
          .values
          .toList(),
    );
  }
}
