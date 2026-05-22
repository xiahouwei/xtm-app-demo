import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/business/business_page.dart';
import 'package:flutter_proj/pages/home/home_page.dart';
import 'package:flutter_proj/pages/message/message_page.dart';
import 'package:flutter_proj/pages/mine/mine_page.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/widgets/lazy_indexed_stack.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/toast/xtm_toast.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 基座页面
class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomBarIndex = 0;
  DateTime _lastPressedTime;
  final _homeKey = GlobalKey<HomePageState>();
  final _businessKey = GlobalKey<BusinessPageState>();
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
            BusinessPage(key: _businessKey),
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
                _buildTabItem(
                  index: 0,
                  iconPath: 'assets/icons/bottom_bar/icon_home.png',
                  selectedIconPath: 'assets/icons/bottom_bar/icon_home_select.png',
                  label: '首页',
                ),
                _buildTabItem(
                  index: 1,
                  iconPath: 'assets/icons/bottom_bar/icon_business.png',
                  selectedIconPath: 'assets/icons/bottom_bar/icon_business_select.png',
                  label: '业务',
                ),
                _buildTabItem(
                  index: 2,
                  iconPath: 'assets/icons/bottom_bar/icon_msg.png',
                  selectedIconPath: 'assets/icons/bottom_bar/icon_msg_select.png',
                  label: '消息',
                ),
                _buildTabItem(
                  index: 3,
                  iconPath: 'assets/icons/bottom_bar/icon_mine.png',
                  selectedIconPath: 'assets/icons/bottom_bar/icon_mine_select.png',
                  label: '我的',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
      {int index, String iconPath, String selectedIconPath, String label}) {
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
              _businessKey.currentState?.appRefresh();
              break;
            case 2:
              _messageKey.currentState?.appRefresh();
              break;
            case 3:
              _mineKey.currentState?.appRefresh();
              break;
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _bottomBarIndex == index
                    ? Image.asset(selectedIconPath, width: 28, height: 28, fit: BoxFit.fill)
                    : Image.asset(iconPath, width: 28, height: 28, fit: BoxFit.fill),
                SizedBox(height: 4),
                _buildItemText(index: index, label: label),
              ],
            ),
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
