import 'package:flutter_proj/xtmdesign_component/src/components/icon/state_text_icon.dart';

class CommonConstant {
  /// 每页默认加载的条数
  static const int PAGE_SIZE = 10;

  /// 角色
  static const int ROLE_DRIVER = 1;
}

/// 审核状态  0:待审核、1:审核通过、2:审核驳回
class AuditStatusConstant {
  static const int WAIT_AUDIT = 0;
  static const int AUDIT_SUCCESS = 1;
  static const int AUDIT_FAIL = 2;

  static String getStatusText(int status) {
    switch (status) {
      case WAIT_AUDIT:
        return '待审核';
      case AUDIT_SUCCESS:
        return '审核通过';
      case AUDIT_FAIL:
        return '审核驳回';
      default:
        return '';
    }
  }

  static getStateColorEnum(int status) {
    switch (status) {
      case WAIT_AUDIT:
        return StateColorEnum.STATE_ORANGE;
      case AUDIT_SUCCESS:
        return StateColorEnum.STATE_GREEN;
      case AUDIT_FAIL:
        return StateColorEnum.STATE_RED;
      default:
        return StateColorEnum.STATE_BLUE;
    }
  }
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

/// 驾驶证类型
class DriverLicenseTypeConstants {
  static const String TYPE_A1_CODE = '2951010';
  static const String TYPE_A2_CODE = '2951020';
  static const String TYPE_A1A2_CODE = '2951160';
  static const String TYPE_A3_CODE = '2951030';
  static const String TYPE_B1_CODE = '2951040';
  static const String TYPE_B2_CODE = '2951050';
  static const String TYPE_C1_CODE = '2951060';
  static const String TYPE_C2_CODE = '2951070';
  static const String TYPE_C3_CODE = '2951080';
  static const String TYPE_C4_CODE = '2951090';
  static const String TYPE_D_CODE = '2951100';
  static const String TYPE_E_CODE = '2951110';
  static const String TYPE_F_CODE = '2951120';
  static const String TYPE_M_CODE = '2951130';
  static const String TYPE_N_CODE = '2951140';
  static const String TYPE_P_CODE = '2951150';

  static String getTypeName(String typeCode) {
    switch (typeCode) {
      case TYPE_A1_CODE:
        return 'A1';
      case TYPE_A2_CODE:
        return 'A2';
      case TYPE_A1A2_CODE:
        return 'A1A2';
      case TYPE_A3_CODE:
        return 'A3';
      case TYPE_B1_CODE:
        return 'B1';
      case TYPE_B2_CODE:
        return 'B2';
      case TYPE_C1_CODE:
        return 'C1';
      case TYPE_C2_CODE:
        return 'C2';
      case TYPE_C3_CODE:
        return 'C3';
      case TYPE_C4_CODE:
        return 'C4';
      case TYPE_D_CODE:
        return 'D';
      case TYPE_E_CODE:
        return 'E';
      case TYPE_F_CODE:
        return 'F';
      case TYPE_M_CODE:
        return 'M';
      case TYPE_N_CODE:
        return 'N';
      case TYPE_P_CODE:
        return 'P';
      default:
        return '未知';
    }
  }
}

/// IM开关
class AppImSwitch {
  // 关
  static const int CLOSE = 0;

  // 开
  static const int OPEN = 1;
}
