import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:flutter_proj/common/function/auth_manager.dart';

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);
  @override
  State<MinePage> createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  int count = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XtmColor.bgColor,
      appBar: XtmAppBar(title: '消息'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: buildContentWidget(),
      ),
    );
  }

  Widget buildContentWidget() {
    return Column(
      children: [
        Text('消息-第${count}次进入'),
        XtmTextButton(
          text: '退出登录',
          onPressed: () {
            AuthManager.clearToLogin();
          },
        ),
      ],
    );
  }

  void appRefresh() {
    setState(() {
      count++;
    });
  }
}
