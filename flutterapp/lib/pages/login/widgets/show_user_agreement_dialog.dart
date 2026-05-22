import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:flutter_proj/common/h5_page/h5_page_manage.dart';

class ShowUserAgreementDialog {
  static void showAgreementDialog(BuildContext context, VoidCallback agreeActionOnPress) {
    XtmConfirmDialog.show(
      context,
      title: '用户使用协议',
      customContent: _displayProtocol(),
      leftBtnTitle: '不同意',
      rightBtnTitle: '同意',
    ).then(
      (action) => {agreeActionOnPress()},
    );
  }

  static Widget _displayProtocol() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: '为了更好地保障您的合法权益，请您阅读并同意以下协议',
                style: TextStyle(
                    color: Colors.black87, fontSize: 16 * xtmGlobalStore.system.fontScale)),
            TextSpan(
              text: '《小铁马平台用户使用协议》',
              style: TextStyle(color: XtmColor.themeColor, fontSize: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  H5PageManager.navigator2UserAgreementPage();
                },
            ),
            TextSpan(
                text: '《隐私政策》',
                style: TextStyle(color: XtmColor.themeColor, fontSize: 14),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    H5PageManager.navigator2PrivacyAgreementPage();
                  }),
            TextSpan(
                text: '《平台交易规则协议》',
                style: TextStyle(color: XtmColor.themeColor, fontSize: 14),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    H5PageManager.navigator2PlatformTransactionRulesPage();
                  }),
          ],
        ),
      ),
    );
  }
}
