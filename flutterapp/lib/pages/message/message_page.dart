import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';


class MessagePage extends StatefulWidget {
  MessagePage({Key key}) : super(key: key);
  @override
  State<MessagePage> createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
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
        title: '消息中心',
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
