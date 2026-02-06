import 'package:flutter_proj/xtmdesign_component/src/components/icon/state_text_icon.dart';

class CommonConstant {
  /// 每页默认加载的条数
  static const int PAGE_SIZE = 10;

  /// 角色
  static const int ROLE_DRIVER = 1;
}

/// 文件上传业务源
class UploadBusSourceConstant {
  /// 车辆管理相关
  static const String VEHICLE_MANAGE = 'BASICWEB_VEHICLE';
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

class CompanyTypeConstant {
  /// 0: 采购商

  static const int PURCHASER = 0;

  /// 1: 供应商
  static const int SUPPLIER = 1;

  /// 2：承运商
  static const int CARRIER = 2;

  static String getCompanyTypeText(int type) {
    switch (type) {
      case PURCHASER:
        return '采购商';
      case SUPPLIER:
        return '供应商';
      case CARRIER:
        return '承运商';
      default:
        return '';
    }
  }
}
