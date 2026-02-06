import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/widgets/lazy_indexed_stack.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/toast/xtm_toast.dart';
import 'package:flutter_proj/pages/home/home_page.dart';
import 'package:flutter_proj/pages/waybill/waybill_page.dart';
import 'package:flutter_proj/pages/message/message_page.dart';
import 'package:flutter_proj/pages/mine/mine_page.dart';

/// 基座页面
class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomBarIndex = 0;
  DateTime _lastPressedTime;
  final _homeKey = GlobalKey<HomePageState>();
  final _waybillKey = GlobalKey<WaybillPageState>();
  final _messageKey = GlobalKey<MessagePageState>();
  final _mineKey = GlobalKey<MinePageState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _exitApp(),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: LazyIndexedStack(
          index: _bottomBarIndex,
          children: [
            HomePage(key: _homeKey),
            WaybillPage(key: _waybillKey),
            MessagePage(key: _messageKey),
            MinePage(key: _mineKey),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(index: 0, icon: Icons.home, label: '首页'),
                _buildTabItem(index: 1, icon: Icons.app_registration, label: '运单'),
                _buildTabItem(index: 2, icon: Icons.message, label: '消息'),
                _buildTabItem(index: 3, icon: Icons.person, label: '我的'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({int index, IconData icon, String label}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _bottomBarIndex = index;
          });
          switch (index) {
            case 0:
              _homeKey.currentState?.appRefresh();
              break;
            case 1:
              _waybillKey.currentState?.appRefresh();
              break;
            case 2:
              _messageKey.currentState?.appRefresh();
              break;
            case 3:
              _mineKey.currentState?.appRefresh();
              break;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: _bottomBarIndex == index ? Color(0xFF1773FF) : XtmColor.gray,
            ),
            SizedBox(height: 4),
            _buildItemText(index: index, label: label)
          ],
        ),
      ),
    );
  }

  Widget _buildItemText({int index, String label}) {
    return Text(
      label,
      style: TextStyle(
        color: _bottomBarIndex == index ? XtmColor.themeColor : XtmColor.black,
        fontSize: 12,
      ),
    );
  }

  bool _exitApp() {
    if (_lastPressedTime == null ||
        DateTime.now().difference(_lastPressedTime) > Duration(seconds: 1)) {
      _lastPressedTime = DateTime.now();
      XtmToast.info('再按一次退出应用');
      return false;
    }
    return true;
  }
}
