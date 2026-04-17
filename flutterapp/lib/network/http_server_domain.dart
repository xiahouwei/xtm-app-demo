import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';

class DomainModel {
  String platformName;
  String envDomain;

  DomainModel(this.platformName, this.envDomain);
}

enum ServerDomainType { RELEASE, PRE, DEV, SIT3, QA }

class HttpServerDomain {
  static final List<DomainModel> _releaseEnv = [
    DomainModel('河北纵横集团丰南钢铁有限公司', 'https://www.tjzwzn.cn'),
  ];

  static final List<DomainModel> _preEnv = [
    DomainModel('河北纵横集团丰南钢铁有限公司', 'https://pre-9ms-zt.tjzwzn.cn'),
  ];

  static final List<DomainModel> _devEnv = [
    DomainModel('dev-河北纵横丰南', 'https://dev-9ms.fengnansteel.com'),
  ];

  static final List<DomainModel> _sit3Env = [
    DomainModel('sit3', 'https://sit3.tjzwzn.cn/tms'),
  ];
  static final List<DomainModel> _qaEnv = [
    DomainModel('qa', 'https://qa.tjzwzn.cn/tms'),
  ];

  static List<DomainModel> getServerDomainList() {
    switch (HTTPConfig.serverDomainType) {
      case ServerDomainType.RELEASE:
        return _releaseEnv;
      case ServerDomainType.PRE:
        return _preEnv;
      case ServerDomainType.DEV:
        return _devEnv;
      case ServerDomainType.SIT3:
        return _sit3Env;
      case ServerDomainType.QA:
        return _qaEnv;
      default:
        return _devEnv;
    }
  }

  static List<String> getServerDomainNameList() {
    List<DomainModel> _domains = HttpServerDomain.getServerDomainList();
    return _domains.map((e) => e.platformName).toList();
  }

  static DomainModel getDefaultServerDomainModel() {
    List<DomainModel> _domains = HttpServerDomain.getServerDomainList();
    String baseName = xtmGlobalStore.auth.platformName;
    if (baseName.isNotEmpty) {
      return _domains.firstWhere(
        (e) => e.platformName == baseName,
        orElse: () => _domains.first,
      );
    }
    return _domains.first;
  }

  static DomainModel getServerDomainModelByPlatformName(String baseName) {
    List<DomainModel> _domains = HttpServerDomain.getServerDomainList();
    return _domains.firstWhere((item) => item.platformName == baseName);
  }
}
