import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int count = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XtmColor.bgColor,
      appBar: XtmAppBar(title: '首页'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: buildContentWidget(),
      ),
    );
  }

  Widget buildContentWidget() {
    return Text('首页-第${count}次进入');
  }

  void appRefresh() {
    setState(() {
      count++;
    });
  }
}
