import 'package:flutter/material.dart';

/// 块级标题
/// [XtmBlockHeader] 块级UI的标题，自带蓝色渐变下划线
///
/// 示例：
/// XtmBlockHeader(headerTitle: '运输码')

class XtmBlockHeader extends StatelessWidget {
  final String headerTitle;

  const XtmBlockHeader({Key key, this.headerTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
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
        Text(
          headerTitle,
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
