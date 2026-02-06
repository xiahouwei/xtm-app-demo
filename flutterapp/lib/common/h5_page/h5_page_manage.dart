import 'package:flutter/material.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:flutter_proj/widgets/webView/web_view_page.dart';
import 'package:flutter_proj/common/h5_page/h5_url_manage.dart';

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

  /// 跳转到客服页面
  static Future<void> navigator2ImPage() {
    String url = H5UrlManager.getImWebPageUrl();
    return Navigator.push(
      NavigatorProvider.navigatorContext,
      MaterialPageRoute(builder: (BuildContext context) {
        return new WebViewPage(
          urlString: url,
          resizeToAvoidBottomInset: true,
          clearCache: false,
          webviewPopBySelf: true,
        );
      }),
    );
  }
}
