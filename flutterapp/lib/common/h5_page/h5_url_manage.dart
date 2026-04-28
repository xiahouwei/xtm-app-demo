import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';

class H5UrlManager {
  /// 用户使用协议页面
  static String getUserAgreementUrl() {
    return '${HTTPConfig.serverDomain}/api/appApi/platAgreementHtmlQry' +
        '?app_key=${HTTPConfig.appKey}&agreementType=4360010';
  }

  /// 隐私政策页面
  static String getPrivacyAgreementUrl() {
    return '${HTTPConfig.serverDomain}/api/appApi/platAgreementHtmlQry' +
        '?app_key=${HTTPConfig.appKey}&agreementType=4360020';
  }

  /// 客服页面
  static String getImWebPageUrl() {
    return '${HTTPConfig.chatDomain}/?version=${DateTime.now().millisecondsSinceEpoch}'
        '#/client_chat?userId=${xtmGlobalStore.auth.userInfo.userID}'
        '&userName=${xtmGlobalStore.auth.userInfo.userName}&token=${xtmGlobalStore.auth.token}&appType=2';
  }

  /// 滑动验证码页面
  static String getCaptchaUrl() {
    return '${HTTPConfig.getHost}/xiaoniuh5/#/captcha';
  }
}
