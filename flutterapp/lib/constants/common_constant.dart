/// 常用常量
class CommonConstant {
  /// 每页默认加载的条数
  static const int PAGE_SIZE = 10;

  /// 普通用户（未认证用户）
  static int NORMAL_USER = 2541080;

  /// 托运人
  static const int SHIPPER = 2541010;

  /// 托运代办人
  static const int SHIPPER_AGENT = 2541060;
}

/// 认证状态
class CertifyStatusConstant {
  /// 0未认证
  static const int UN_CERTIFY = 0;

  /// 1已认证
  static const int CERTIFIED = 1;
}

/// 文件上传业务源
class UploadBusSourceConstant {
  /// 业务
  static const String APP_SHIPPER_BUSINESS = 'APP_SHIPPER_BUSINESS';

  /// 公司
  static const String APP_SHIPPER_COMPANY = 'APP_SHIPPER_COMPANY';

  /// 用户
  static const String APP_SHIPPER_USER = 'APP_SHIPPER_USER';
}
