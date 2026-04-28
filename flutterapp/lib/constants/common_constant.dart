class CommonConstant {
  /// 每页默认加载的条数
  static const int PAGE_SIZE = 10;

  /// 角色
  static const int ROLE_DRIVER = 1;
}

class AppChannel {
  static const String appChannelName = "transport";
}

/// 文件上传业务源
class UploadBusSourceConstant {
  /// 车辆管理相关
  static const String VEHICLE_MANAGE = 'BASICWEB_VEHICLE';

  /// 用户头像
  static const String HEAD_PHOTO = 'HEAD_PHOTO';

  /// 企业认证
  static const String COMPANY_AUTH = 'CUSTOMER_ARCHIVE';

  /// 为他人注册司机
  static const String REGISTER_DRIVER_FOR_OTHER = 'REGISTER_DRIVER_FOR_OTHER';

  /// 创建运力单元签署协议
  static const String TCU_FILE = 'TCU_FILE';
}
