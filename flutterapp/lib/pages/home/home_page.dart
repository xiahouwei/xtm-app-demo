import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
        title: '首页',
        backgroundColor: _theme.appBarColor,
        elevation: 0,
        leftWidget: SizedBox.shrink(),
      ),
      body: XtmAppBody(
        backgroundColor: _theme.pageBgColor,
        child: Stack(
          children: [],
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
