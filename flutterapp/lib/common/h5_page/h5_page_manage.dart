import 'package:flutter/material.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:flutter_proj/widgets/webView/web_view_page.dart';

class H5UrlManager {
  /// 隐私政策页面
  static String getPrivacyAgreementUrl() {
    return 'https://www.tjzwzn.cn/upload/WHITE/ep_privacy_agreement_20250618.html';
  }
}

class H5PageManange {
  /// 跳转到隐私政策页面
  static void navigator2PrivacyAgreementPage() {
    String url = H5UrlManager.getPrivacyAgreementUrl();
    Navigator.push(
      NavigatorProvider.navigatorContext,
      new MaterialPageRoute(builder: (BuildContext context) {
        return WebViewPage(urlString: url, titleStr: '隐私政策', showProgress: true);
      }),
    );
  }
}
