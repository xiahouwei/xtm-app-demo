import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/constants/common_constant.dart';
import 'package:flutter_proj/models/login/user_info_model.dart';
import 'package:flutter_proj/pages/login/login_page.dart';
import 'package:flutter_proj/pages/mine/bind_info/bind_info_page.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/widgets/image/image_display.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

import './personal_info/personal_info_page.dart';

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);
  @override
  State<MinePage> createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  UserInfoModel _userInfo = xtmGlobalStore.auth.userInfo;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/mine/mine_header_bg.png'),
        SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 10),
                _buildCompanyName(),
                SizedBox(height: 20),
                _buildContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Row(
        children: [
          _buildAvatar(),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userInfo.userName ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: XtmColor.mainTextColor,
                ),
              ),
              SizedBox(height: 15),
              Text(_userInfo.mobile ?? ''),
            ],
          ),
          Spacer(),
          XtmStateTextIcon(
            AuditStatusConstant.getStatusText(_userInfo.auditStatus),
            AuditStatusConstant.getStateColorEnum(_userInfo.auditStatus),
            fontSize: 12,
            width: 60,
          ),
          IconButton(
            onPressed: () {
              XtmConfirmDialog.show(
                context,
                message: '是否确定退出登录',
              ).then((action) => logoutHandle());
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return DisplayImage(
      imgId: '',
      fit: BoxFit.fill,
      width: 70,
      height: 70,
      errorBuilder: (_, __, ___) {
        return Image.asset(
          'assets/images/mine/mine_avatar_icon.png',
          width: 80,
        );
      },
    );
  }

  Widget _buildCompanyName() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD0E6FE),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Text(
            xtmGlobalStore.auth.platformName,
            style: TextStyle(
              color: XtmColor.mainTextColor,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              XtmConfirmDialog.show(
                context,
                message: '切换基地需退出当前账号并重新登录，是否确认切换？',
              ).then((action) => logoutHandle());
            },
            icon: Icon(
              Icons.change_circle,
              color: XtmColor.blue,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          XtmCell(
            label: '个人信息',
            leftWidget: Icon(
              Icons.add_moderator,
              color: XtmColor.blue,
              size: 16,
            ),
            showDivider: false,
            onCellTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalInfoPage(userInfo: _userInfo),
                ),
              ).then((value) {
                if (value != null && value['dataChanged']) {
                  getUserInfo();
                }
              });
            },
          ),
          XtmCell(
            label: '绑定信息',
            leftWidget: Icon(
              Icons.link,
              color: XtmColor.blue,
              size: 16,
            ),
            showDivider: false,
            onCellTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BindInfoPage()),
              );
            },
          ),
          XtmCell(
            label: '个人中心',
            leftWidget: Icon(
              Icons.person,
              color: XtmColor.blue,
              size: 16,
            ),
            showDivider: false,
          ),
          XtmCell(
            label: '免责声明',
            leftWidget: Icon(
              Icons.topic,
              color: XtmColor.blue,
              size: 16,
            ),
            showDivider: false,
          ),
          XtmCell(
            label: '设置',
            leftWidget: Icon(
              Icons.settings,
              color: XtmColor.blue,
              size: 16,
            ),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  void logoutHandle() async {
    XtmToast.success('退出成功');
    xtmGlobalStore.auth.setIsLogin(false);
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
  }

  void getUserInfo() {
    Map<String, dynamic> params = {};
    params['userId'] = xtmGlobalStore.auth.userInfo.userID;
    xtmApi.auth.getUserinfoAPi(params: params).then((res) {
      UserInfoModel userInfo = UserInfoModel.fromJson(res['userInfo']);
      if (userInfo != null) {
        setState(() {
          _userInfo = userInfo;
        });
      }
    });
  }

  void appRefresh() {
    setState(() {
      getUserInfo();
    });
  }
}
