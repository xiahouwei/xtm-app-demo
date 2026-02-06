import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:flutter_proj/common/h5_page/h5_page_manage.dart';

class UserNoticeDialog {
  static showProtocolView() {
    showDialog(
      context: NavigatorProvider.navigatorContext,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        child: _buildDialogView(),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  static Widget _buildDialogView() {
    return AlertDialog(
      title: Center(
        child: Text('用户须知'),
      ),
      actionsAlignment: MainAxisAlignment.center,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topContent(),
            _factoryText(textStr: '1、存储权限，用于必要的信息存储，比如图片、运行日志等。'),
            _factoryText(textStr: '2、位置权限，用于根据定位推送货源、订单，获取订单运输轨迹。'),
            _factoryText(textStr: '3、相机权限，用于注册上传证件照片，人脸识别以及拍摄运输货物、回单。'),
            _factoryText(textStr: '4、相册权限，用于注册上传证件照片以及上传已拍的运输货物照片和回单照片。'),
            _factoryText(textStr: '5、电话权限，用于订单运输过程中联系客户和客服咨询。'),
          ],
        ),
      ),
      actions: [
        _denyBtnAction(),
        _confirmBtnAction(),
      ],
    );
  }

  static Widget _factoryText({@required String textStr}) {
    return RichText(
        text: TextSpan(
            text: textStr,
            style: TextStyle(
              color: Color.fromRGBO(100, 100, 100, 1.0),
              fontSize: 15,
            )));
  }

  static Widget _topContent() {
    double fontSize = 15;
    FontWeight fontWeight = FontWeight.bold;
    Color highLightColor = Color.fromRGBO(14, 159, 255, 1.0);
    return RichText(
        text: TextSpan(children: [
      _factoryTextSpan(textStr: '    使用前，请您先阅读'),
      TextSpan(
        text: '《隐私政策》',
        style: TextStyle(color: highLightColor, fontWeight: fontWeight, fontSize: fontSize),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            H5PageManange.navigator2PrivacyAgreementPage();
          },
      ),
      _factoryTextSpan(textStr: '，并充分了解以下权限申请情况：'),
    ]));
  }

  static TextSpan _factoryTextSpan({@required String textStr}) {
    double fontSize = 15;
    FontWeight fontWeight = FontWeight.bold;
    Color blackColor = Colors.black;
    return TextSpan(
        text: textStr,
        style: TextStyle(color: blackColor, fontWeight: fontWeight, fontSize: fontSize));
  }

  static Widget _denyBtnAction() {
    return TextButton(
      child: Container(
        // width: 115,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Color.fromRGBO(142, 142, 142, 1.0),
        ),
        child: Center(
          child: Text(
            '不同意并退出',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
      onPressed: () {
        Navigator.of(NavigatorProvider.navigatorContext).pop();
        exit(0);
      },
    );
  }

  static Widget _confirmBtnAction() {
    return TextButton(
      child: Container(
        // width: 115,
        margin: EdgeInsets.only(bottom: 20),
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: XtmColor.themeColor,
        ),
        child: Center(
          child: Text(
            '阅读并同意',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
      onPressed: () {
        xtmGlobalStore.auth.setShowSecretDialog(false);
        Navigator.of(NavigatorProvider.navigatorContext).pop();
      },
    );
  }
}
