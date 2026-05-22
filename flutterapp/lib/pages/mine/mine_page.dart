import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';


class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);

  @override
  State<MinePage> createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  ThemeNotifier _theme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Scaffold(
      appBar: XtmAppBar(
        title: '我的',
        backgroundColor: _theme.appBarColor,
        elevation: 0,
      ),
      body: XtmAppBody(
        backgroundColor: _theme.pageBgColor,
        child: Stack(
          children: [
          ],
        ),
      ),
    );
  }
  void appRefresh() {}


  @override
  void dispose() {
    super.dispose();
  }
}
