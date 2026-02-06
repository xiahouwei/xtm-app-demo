enum ImageTypeEnum {
  /// 默认图片
  DEFAULT_IMG,

  /// 行驶证主页
  DRIVING_LICENSE_MAIN,

  /// 行驶证主页-不可点击
  DRIVING_LICENSE_MAIN_NO_CLICK,

  /// 道路运输证
  ROAD_TRANSPORT,

  /// 道路运输证-不可点击
  ROAD_TRANSPORT_NO_CLICK,
}

/// 图片识别类型
class OcrTypeConstants {
  /// 银行卡
  static const String BANK_TYPE = 'bank_type';

  /// 驾驶证
  static const String DRIVER_TYPE = 'driver_type';

  /// 身份证
  static const String ID_TYPE = 'id_type';

  /// 营业执照
  static const String BUSINESS_LICENSE = 'business_license';

  /// 行驶证
  static const String RUNNING_TYPE = 'running_type';

  /// 道路运输证
  static const String VEHICLE_ROAD = 'vehicle_road';

  /// 从业资格证
  static const String QUALIFICATION_TYPE = 'qualification_type';
}

class ImageConstants {
  /// 获取占位图
  static String getPlaceholderImagePath(ImageTypeEnum type) {
    switch (type) {
      case ImageTypeEnum.DRIVING_LICENSE_MAIN:
        return 'assets/images/placeholder/placeholder_driving_license_main.png';
      case ImageTypeEnum.DRIVING_LICENSE_MAIN_NO_CLICK:
        return 'assets/images/placeholder/placeholder_driving_license_main_no_click.png';
      case ImageTypeEnum.ROAD_TRANSPORT:
        return 'assets/images/placeholder/placeholder_road_transport.png';
      case ImageTypeEnum.ROAD_TRANSPORT_NO_CLICK:
        return 'assets/images/placeholder/placeholder_road_transport_no_click.png';
      case ImageTypeEnum.DEFAULT_IMG:
      default:
        return 'assets/images/placeholder/placeholder_default.png';
    }
  }

  /// 获取图片识别类型
  static String getImageOcrType(ImageTypeEnum type) {
    switch (type) {
      case ImageTypeEnum.DRIVING_LICENSE_MAIN:
        return OcrTypeConstants.RUNNING_TYPE;
      case ImageTypeEnum.ROAD_TRANSPORT:
        return OcrTypeConstants.VEHICLE_ROAD;
      case ImageTypeEnum.DEFAULT_IMG:
      default:
        return '';
    }
  }

  /// 获取图片识别正反面
  static String getImageSide(ImageTypeEnum type) {
    switch (type) {
      case ImageTypeEnum.DRIVING_LICENSE_MAIN:
        return 'front';
      case ImageTypeEnum.ROAD_TRANSPORT:
        return 'front';
      case ImageTypeEnum.DEFAULT_IMG:
      default:
        return '';
    }
  }
}
