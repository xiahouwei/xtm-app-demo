import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/widgets/list_view/app_list_container.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:provider/provider.dart';

class BusinessTabIndexConstants {
  static int CONTRACT_INDEX = 0;
  static int BILL_INDEX = 1;
}

class BusinessPage extends StatefulWidget {
  BusinessPage({Key key}) : super(key: key);

  @override
  State<BusinessPage> createState() => BusinessPageState();
}

class BusinessPageState extends State<BusinessPage> {
  TextEditingController _searchController = TextEditingController();
  final GlobalKey<XtmTabBarState> _tabBarKey = GlobalKey();
  int tabBarActive = BusinessTabIndexConstants.CONTRACT_INDEX;

  String get _searchBarLabel {
    if (tabBarActive == BusinessTabIndexConstants.CONTRACT_INDEX) {
      return '合同编号';
    }
    return '订单号';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeNotifier>(context, listen: true);
    return XtmAppBody(
      backgroundColor: _theme.pageBgColor,
      child: AppListContainer(
        topWidget: XtmSearchBar(
          controller: _searchController,
          label: _searchBarLabel,
          onSearch: (value) {
          },
        ),
        listWidget: _buildOrderList(),
      ),
    );
  }

  Widget _buildOrderList() {
    return XtmTabBar(
        key: _tabBarKey,
        tabList: [
          XtmTab(title: '合同', widget: SizedBox()),
          XtmTab(title: '订单', widget: SizedBox()),
        ],
        onChanged: (value) {
          setState(() {
            tabBarActive = value;
          });
        });
  }

  void appRefresh() {}
}
