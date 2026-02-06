import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class WaybillPage extends StatefulWidget {
  WaybillPage({Key key}) : super(key: key);
  @override
  State<WaybillPage> createState() => WaybillPageState();
}

class WaybillPageState extends State<WaybillPage> {
  int count = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XtmColor.bgColor,
      appBar: XtmAppBar(title: '运单'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: buildContentWidget(),
      ),
    );
  }

  Widget buildContentWidget() {
    return Text('运单-第${count}次进入');
  }

  void appRefresh() {
    setState(() {
      count++;
    });
  }
}
