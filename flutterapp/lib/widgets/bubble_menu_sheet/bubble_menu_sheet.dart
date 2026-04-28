import 'package:flutter/material.dart';

class BubbleMenuSheet extends StatelessWidget {
  final Size itemSize;
  final Offset containerOffset;
  final List<String> titles;
  final ValueChanged<int> onTap;
  const BubbleMenuSheet({
    @required this.itemSize,
    @required this.containerOffset,
    @required this.titles,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            left: containerOffset.dx,
            top: containerOffset.dy - itemSize.height * titles.length - 12 *2,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)
                  ),
                  width: itemSize.width,
                  child: buildItems(),
                ),
              ],

            ),
          )
        ],
      ),
    );
  }

  Widget buildItems() {
    List<Widget> widgets = [];
    for(int i = 0; i < titles.length; i++) {
      widgets.add(buildCellItem(i, titles[i]));
      if (i != titles.length-1) {
        widgets.add(buildDividerLine());
      }
    }
    return Column(
        children: widgets
    );
  }

  Widget buildCellItem(int index, String title) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        height: itemSize.height,
        child: Text(
          '$title',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap(index);
        }
      },
    );
  }

  Widget buildDividerLine() {
    return Container(
      color: Colors.black,
      height: 0.5,
    );
  }

}
