import 'package:flutter/cupertino.dart';
import 'package:flutter_proj/widgets/bubble_menu_sheet/bubble_menu_sheet.dart';

void showBubbleMenuSheet(
  BuildContext context,
  GlobalKey globalKey,
  List<String> titles, {
  ValueChanged<int> onTap,
}) {
  Rect frame = _getWidgetSize(globalKey);
  double width = 140;
  double height = 44;
  showGeneralDialog(
    context: context,
    pageBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: BubbleMenuSheet(
            containerOffset: Offset(frame.left, frame.top),
            itemSize: Size(width, height),
            titles: titles,
            onTap: (int index) {
              Navigator.of(context).pop();
              if (onTap != null) {
                onTap(index);
              }
            },
          ),
        ),
      );
    },
  );
}

///获取更多按钮的位置
Rect _getWidgetSize(GlobalKey key) {
  final RenderBox renderBox = (key.currentContext?.findRenderObject() as RenderBox);
  final left = renderBox.localToGlobal(Offset.zero).dx;
  final top = renderBox.localToGlobal(Offset(renderBox.size.width, 0)).dy;
  final bottom = renderBox.localToGlobal(Offset(0, renderBox.size.height)).dy;
  final right = renderBox.localToGlobal(Offset(renderBox.size.width, renderBox.size.height)).dx;
  return Rect.fromLTRB(left, top, right, bottom);
}
