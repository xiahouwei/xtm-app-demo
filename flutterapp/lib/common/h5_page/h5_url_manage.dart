import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';

class H5UrlManager {
  /// 隐私政策页面
  static String getPrivacyAgreementUrl() {
    return 'https://www.tjzwzn.cn/upload/WHITE/ep_privacy_agreement_20250618.html';
  }

  /// 客服页面
  static String getImWebPageUrl() {
    return '${HTTPConfig.chatDomain}/?version=${DateTime.now().millisecondsSinceEpoch}'
        '#/client_chat?userId=${xtmGlobalStore.auth.userInfo.userID}'
        '&userName=${xtmGlobalStore.auth.userInfo.userName}&token=${xtmGlobalStore.auth.token}';
  }

  /// 滑动验证码页面
  static String getCaptchaUrl() {
    return '${HTTPConfig.getHost}/xiaoniuh5/#/captcha';
  }
}
