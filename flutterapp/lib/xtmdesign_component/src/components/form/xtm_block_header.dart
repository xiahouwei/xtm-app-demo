import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/src/xtm_design_config.dart';

/// 块级标题
/// [XtmBlockHeader] 块级UI的标题，自带蓝色渐变下划线
///
/// 示例：
/// XtmBlockHeader(headerTitle: '运输码')

enum HeaderLineType {
  LEFT_LINE,
  BOTTOM_LINE,
}

class XtmBlockHeader extends StatelessWidget {
  final String headerTitle;
  final HeaderLineType lineType;

  const XtmBlockHeader({
    Key key,
    this.headerTitle,
    this.lineType = HeaderLineType.BOTTOM_LINE,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: lineType == HeaderLineType.BOTTOM_LINE,
          child: Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: 5,
              child: Image.asset(
                'lib/xtmdesign_component/assets/images/form_header_bg.png',
                width: 60,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: lineType == HeaderLineType.LEFT_LINE,
              child: Container(
                height: 20,
                width: 3,
                color: xtmDesignConfig.mainColor,
              ),
            ),
            SizedBox(width: 5),
            Text(
              headerTitle,
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
