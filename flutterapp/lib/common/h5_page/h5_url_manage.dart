import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/config/app_config.dart';

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

  /// 平台交易规则协议
  static String getPlatformTransactionRules() {
    return '${HTTPConfig.serverDomain}/api/appApi/platAgreementHtmlQry' +
        '?app_key=${HTTPConfig.appKey}&agreementType=4360040';
  }

  /// 客服页面
  static String getImWebPageUrl() {
    return '${HTTPConfig.chatDomain}/?version=${DateTime.now().millisecondsSinceEpoch}'
        '#/client_chat?userId=${xtmGlobalStore.auth.userInfo.userID}'
        '&userName=${xtmGlobalStore.auth.userInfo.userName}&token=${xtmGlobalStore.auth.token}&appType=${AppConfig.APP_IM_CHAT_TYPE}';
  }

  /// 滑动验证码页面
  static String getCaptchaUrl() {
    return '${HTTPConfig.getHost}/xiaoniuh5/#/captcha';
  }
}
