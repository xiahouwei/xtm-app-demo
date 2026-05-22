enum ImageTypeEnum {
  /// 默认图片
  DEFAULT_IMG,
  DEFAULT_IMG_NO_CLICK,

  /// 行驶证主页
  DRIVING_LICENSE_MAIN,
  DRIVING_LICENSE_MAIN_NO_CLICK,

  /// 行驶证副页
  DRIVING_LICENSE_SUB,
  DRIVING_LICENSE_SUB_NO_CLICK,

  /// 行驶证副页背面
  DRIVING_LICENSE_SUB_BACK,
  DRIVING_LICENSE_SUB_BACK_NO_CLICK,

  /// 道路运输证
  ROAD_TRANSPORT,
  ROAD_TRANSPORT_NO_CLICK,

  /// 道路运输经营许可证
  ROAD_TRANSPORT_BUSINESS,
  ROAD_TRANSPORT_BUSINESS_NO_CLICK,

  /// 身份证人像面
  ID_CARD_FRONT,
  ID_CARD_FRONT_NO_CLICK,

  /// 身份证国徽面
  ID_CARD_BACK,
  ID_CARD_BACK_NO_CLICK,

  /// 驾驶证主页
  DRIVER_LICENSE_MAIN,
  DRIVER_LICENSE_MAIN_NO_CLICK,

  /// 驾驶证副页
  DRIVER_LICENSE_SUB,
  DRIVER_LICENSE_SUB_NO_CLICK,

  /// 车辆照片
  VEHICLE,
  VEHICLE_NO_CLICK,

  /// 从业资格证
  PROFESSIONAL_QUALIFICATION,
  PROFESSIONAL_QUALIFICATION_NO_CLICK,

  /// 营业执照
  BUSINESS_LICENSE,
  BUSINESS_LICENSE_NO_CLICK,

  /// 人脸自拍
  FACE,
  FACE_NO_CLICK,

  /// 头像
  USER_HEAD_IMG,

  /// 公司logo
  COMPANY_LOGO,
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
      case ImageTypeEnum.DRIVING_LICENSE_SUB:
        return 'assets/images/placeholder/placeholder_driving_license_sub.png';
      case ImageTypeEnum.DRIVING_LICENSE_SUB_NO_CLICK:
        return 'assets/images/placeholder/placeholder_driving_license_sub_no_click.png';
      case ImageTypeEnum.DRIVING_LICENSE_SUB_BACK:
        return 'assets/images/placeholder/placeholder_driving_license_sub_back.png';
      case ImageTypeEnum.DRIVING_LICENSE_SUB_BACK_NO_CLICK:
        return 'assets/images/placeholder/placeholder_driving_license_sub_back_no_click.png';
      case ImageTypeEnum.ROAD_TRANSPORT:
        return 'assets/images/placeholder/placeholder_road_transport.png';
      case ImageTypeEnum.ROAD_TRANSPORT_NO_CLICK:
        return 'assets/images/placeholder/placeholder_road_transport_no_click.png';
      case ImageTypeEnum.ROAD_TRANSPORT_BUSINESS:
        return 'assets/images/placeholder/placeholder_road_business_license.png';
      case ImageTypeEnum.ROAD_TRANSPORT_BUSINESS_NO_CLICK:
        return 'assets/images/placeholder/placeholder_road_business_license_no_click.png';
      case ImageTypeEnum.ID_CARD_FRONT:
        return 'assets/images/placeholder/placeholder_idcard_front.png';
      case ImageTypeEnum.ID_CARD_FRONT_NO_CLICK:
        return 'assets/images/placeholder/placeholder_idcard_front_no_click.png';
      case ImageTypeEnum.ID_CARD_BACK:
        return 'assets/images/placeholder/placeholder_idcard_back.png';
      case ImageTypeEnum.ID_CARD_BACK_NO_CLICK:
        return 'assets/images/placeholder/placeholder_idcard_back_no_click.png';
      case ImageTypeEnum.DRIVER_LICENSE_MAIN:
        return 'assets/images/placeholder/placeholder_driver_license_main.png';
      case ImageTypeEnum.DRIVER_LICENSE_MAIN_NO_CLICK:
        return 'assets/images/placeholder/placeholder_driver_license_main_no_click.png';
      case ImageTypeEnum.DRIVER_LICENSE_SUB:
        return 'assets/images/placeholder/placeholder_driver_license_sub.png';
      case ImageTypeEnum.DRIVER_LICENSE_SUB_NO_CLICK:
        return 'assets/images/placeholder/placeholder_driver_license_sub_no_click.png';
      case ImageTypeEnum.VEHICLE:
        return 'assets/images/placeholder/placeholder_vehicle.png';
      case ImageTypeEnum.VEHICLE_NO_CLICK:
        return 'assets/images/placeholder/placeholder_vehicle_no_click.png';
      case ImageTypeEnum.PROFESSIONAL_QUALIFICATION:
        return 'assets/images/placeholder/placeholder_qualification_cer.png';
      case ImageTypeEnum.PROFESSIONAL_QUALIFICATION_NO_CLICK:
        return 'assets/images/placeholder/placeholder_qualification_cer_no_click.png';
      case ImageTypeEnum.FACE:
        return 'assets/images/placeholder/placeholder_portrait.png';
      case ImageTypeEnum.FACE_NO_CLICK:
        return 'assets/images/placeholder/placeholder_portrait_no_click.png';
      case ImageTypeEnum.BUSINESS_LICENSE:
        return 'assets/images/placeholder/placeholder_business_license.png';
      case ImageTypeEnum.BUSINESS_LICENSE_NO_CLICK:
        return 'assets/images/placeholder/placeholder_business_license_no_click.png';
      case ImageTypeEnum.USER_HEAD_IMG:
        return 'assets/images/mine/image_mine_portrait.png';
      case ImageTypeEnum.COMPANY_LOGO:
        return 'assets/images/home/image_company_placeholder.png';
      case ImageTypeEnum.DEFAULT_IMG:
        return 'assets/images/placeholder/placeholder_default.png';
      case ImageTypeEnum.DEFAULT_IMG_NO_CLICK:
      default:
        return 'assets/images/placeholder/placeholder_default_no_click.png';
    }
  }

  /// 获取图片识别类型
  static String getImageOcrType(ImageTypeEnum type) {
    switch (type) {
      case ImageTypeEnum.DRIVING_LICENSE_MAIN:
        return OcrTypeConstants.RUNNING_TYPE;
      case ImageTypeEnum.ROAD_TRANSPORT:
        return OcrTypeConstants.VEHICLE_ROAD;
      case ImageTypeEnum.ID_CARD_FRONT:
        return OcrTypeConstants.ID_TYPE;
      case ImageTypeEnum.BUSINESS_LICENSE:
        return OcrTypeConstants.BUSINESS_LICENSE;
      case ImageTypeEnum.DEFAULT_IMG:
      default:
        return '';
    }
  }

  /// 获取图片识别正反面
  static String getImageSide(ImageTypeEnum type) {
    switch (type) {
      case ImageTypeEnum.DRIVING_LICENSE_MAIN:
      case ImageTypeEnum.ROAD_TRANSPORT:
      case ImageTypeEnum.ID_CARD_FRONT:
      case ImageTypeEnum.BUSINESS_LICENSE:
        return 'front';
      case ImageTypeEnum.ID_CARD_BACK:
        return 'back';
      case ImageTypeEnum.DEFAULT_IMG:
      default:
        return '';
    }
  }
}
