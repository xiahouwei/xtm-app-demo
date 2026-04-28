import 'dart:io';

import 'package:flutter_proj/network/http_chat_domain.dart';
import 'package:flutter_proj/network/http_server_domain.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum UME_KIT { OPEN, CLOSE }
enum HTTP_REQUEST_APP_TYPE { NORMAL, TMS }

class ApiVersionIosConstants {
  static const RELEASE = '1.0.0';
  static const PRE = '3.10.9';
  static const DEV = '1.0.0';
  static const SIT3 = '3.10.6';
  static const QA = '3.10.6';
}

class EnvConfig {
  final ServerDomainType serverDomainType;
  final String chatDomain;
  final String chatServiceDomain;
  final String apiVersionIOS;
  final UME_KIT dioKit;
  final UME_KIT umeKit;
  final bool apiLog;

  const EnvConfig({
    this.serverDomainType,
    this.chatDomain,
    this.chatServiceDomain,
    this.apiVersionIOS,
    this.dioKit,
    this.umeKit,
    this.apiLog,
  });

  static const String APP_ENV_DEFAULT = 'release';

  static const Map<String, EnvConfig> _envConfigMap = {
    'release': EnvConfig(
      serverDomainType: ServerDomainType.RELEASE,
      chatDomain: ChatWebDomainConstants.RELEASE,
      chatServiceDomain: ChatServerDomainConstants.RELEASE,
      apiVersionIOS: ApiVersionIosConstants.RELEASE,
      dioKit: UME_KIT.CLOSE,
      umeKit: UME_KIT.CLOSE,
      apiLog: false,
    ),
    'pre': EnvConfig(
      serverDomainType: ServerDomainType.PRE,
      chatDomain: ChatWebDomainConstants.PRE,
      chatServiceDomain: ChatServerDomainConstants.PRE,
      apiVersionIOS: ApiVersionIosConstants.PRE,
      dioKit: UME_KIT.CLOSE,
      umeKit: UME_KIT.CLOSE,
      apiLog: false,
    ),
    'dev': EnvConfig(
      serverDomainType: ServerDomainType.DEV,
      chatDomain: ChatWebDomainConstants.DEV,
      chatServiceDomain: ChatServerDomainConstants.DEV,
      apiVersionIOS: ApiVersionIosConstants.DEV,
      dioKit: UME_KIT.OPEN,
      umeKit: UME_KIT.CLOSE,
      apiLog: true,
    ),
    'sit3': EnvConfig(
      serverDomainType: ServerDomainType.SIT3,
      chatDomain: ChatWebDomainConstants.SIT3,
      chatServiceDomain: ChatServerDomainConstants.SIT3,
      apiVersionIOS: ApiVersionIosConstants.SIT3,
      dioKit: UME_KIT.OPEN,
      umeKit: UME_KIT.CLOSE,
      apiLog: true,
    ),
    'qa': EnvConfig(
      serverDomainType: ServerDomainType.QA,
      chatDomain: ChatWebDomainConstants.QA,
      chatServiceDomain: ChatServerDomainConstants.QA,
      apiVersionIOS: ApiVersionIosConstants.QA,
      dioKit: UME_KIT.OPEN,
      umeKit: UME_KIT.CLOSE,
      apiLog: true,
    ),
    'shw': EnvConfig(
      serverDomainType: ServerDomainType.SIT3,
      chatDomain: ChatWebDomainConstants.SIT3,
      chatServiceDomain: ChatServerDomainConstants.SIT3,
      apiVersionIOS: ApiVersionIosConstants.SIT3,
      dioKit: UME_KIT.OPEN,
      umeKit: UME_KIT.CLOSE,
      apiLog: false,
    ),
    'slw': EnvConfig(
      serverDomainType: ServerDomainType.PRE,
      chatDomain: ChatWebDomainConstants.PRE,
      chatServiceDomain: ChatServerDomainConstants.PRE,
      apiVersionIOS: ApiVersionIosConstants.PRE,
      dioKit: UME_KIT.CLOSE,
      umeKit: UME_KIT.CLOSE,
      apiLog: false,
    ),
  };

  static EnvConfig get current {
    const String appEnv =
        String.fromEnvironment('DART_DEFINE_APP_ENV', defaultValue: APP_ENV_DEFAULT);
    return _envConfigMap[appEnv] ?? _envConfigMap[APP_ENV_DEFAULT];
  }
}

class HTTPConfig {
  static String appKey = 'oSTkfoDh9nk6nPNe3Azhgt';
  static String appSecret = '2CtFi6gzDb2Hq3rRPQzhgt';
  static String aMapKeyAndroid = '40a856c8cbc65117a91cc850a7a5740c';
  static String aMapKeyIOS = 'c54eac435e435bb98176bdd07f8a1e03';
  static String serverDomain = '';
  static String chatDomain = '';
  static String chatServiceDomain = '';
  static ServerDomainType serverDomainType;
  static String serverPath = '/apiPlat/';
  static String apiVersion = '1.0.0';
  static String bundleID = 'com.tjxtm.tmstransport';
  static String baseToken = 'Basic bHBEcml2ZXJBcHA6QWExMjM0NTY=';
  static String terminal = 'transport';
  static HTTP_REQUEST_APP_TYPE appType = HTTP_REQUEST_APP_TYPE.TMS;
  static bool API_LOG = false;

  static String get getHost {
    String domain = HTTPConfig.serverDomain;
    RegExp regex = RegExp(r'/tms$');
    domain = domain.replaceAll(regex, '');
    return domain;
  }

  static Future<void> initHttpConfig() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final appEnvConfig = EnvConfig.current;
    HTTPConfig.serverDomainType = appEnvConfig.serverDomainType;
    HTTPConfig.serverDomain = HttpServerDomain.getDefaultServerDomainModel().envDomain;
    HTTPConfig.chatDomain = appEnvConfig.chatDomain;
    HTTPConfig.chatServiceDomain = appEnvConfig.chatServiceDomain;
    if (Platform.isIOS) {
      HTTPConfig.apiVersion = appEnvConfig.apiVersionIOS;
    } else {
      HTTPConfig.apiVersion = packageInfo.version;
    }
    HTTPConfig.API_LOG = appEnvConfig.apiLog;
  }

  static void updateDomainByPlatformName(String platformName) {
    HTTPConfig.serverDomain =
        HttpServerDomain.getServerDomainModelByPlatformName(platformName).envDomain;
  }

  static void updateDomain(String domain) {
    HTTPConfig.serverDomain = domain;
  }

  static void updateDomainByIos(String mobile) {
    if (Platform.isIOS && mobile != null && mobile == '18232507362') {
      HTTPConfig.serverDomainType = ServerDomainType.PRE;
      HTTPConfig.serverDomain = HttpServerDomain.getDefaultServerDomainModel().envDomain;
      HTTPConfig.chatServiceDomain = ChatServerDomainConstants.PRE;
      HTTPConfig.chatDomain = ChatWebDomainConstants.PRE;
      HTTPConfig.apiVersion = ApiVersionIosConstants.PRE;
    }
  }
}
