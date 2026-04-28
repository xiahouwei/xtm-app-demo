import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class CompanyAuthConstants {
  /// 刷新用户信息
  static const String REFRESH_USER_INFO = 'refresh_user_info';
}

class CompanyAuthImageConstants {
  /// 营业执照
  static const String IMAGE_BUSINESS_LICENSE = 'business_license';

  /// 道路运输经营许可证复印件
  static const String IMAGE_ROAD_TRANSPORT_BUSINESS = 'road_transport_business';

  /// 银行账户
  static const String IMAGE_BANK_INFO = 'bank_info';

  /// 管理员身份证人像面
  static const String IMAGE_ADMIN_ID_CARD_FRONT = 'admin_id_card_front';

  /// 管理员身份证国徽面
  static const String IMAGE_ADMIN_ID_CARD_BACK = 'admin_id_card_back';

  /// 法人身份证复印件
  static const String IMAGE_LEGAL_ID_CARD_COPY = 'legal_id_card_copy';

  /// 法人身份证人像面
  static const String IMAGE_LEGAL_ID_CARD_FRONT = 'legal_id_card_front';

  /// 法人身份证国徽面
  static const String IMAGE_LEGAL_ID_CARD_BACK = 'legal_id_card_back';

  /// 法人授权书
  static const String IMAGE_LEGAL_AUTH_BOOK = 'legal_auth_book';

  /// 其他证件
  static const String IMAGE_OTHER = 'other';
}

/// 审核状态  0:待审核、1:审核通过、2:审核驳回 3: 审核中
class CompanyAuditStatusConstant {
  static const int WAIT_AUDIT = 0;
  static const int AUDIT_SUCCESS = 1;
  static const int AUDIT_FAIL = 2;
  static const int AUDITING = 3;

  static String getStatusText(int status) {
    switch (status) {
      case WAIT_AUDIT:
        return '待审核';
      case AUDIT_SUCCESS:
        return '审核通过';
      case AUDIT_FAIL:
        return '审核驳回';
      case AUDITING:
        return '审核中';
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
      case AUDITING:
      default:
        return StateColorEnum.STATE_BLUE;
    }
  }
}

class CompanyCertifyConstants {
  /// 未认证
  static const int NO_CERTIFY = 0;

  /// 已认证
  static const int PASS_CERTIFY = 1;

  static String getStatusText(int status) {
    switch (status) {
      case NO_CERTIFY:
        return '未认证';
      case PASS_CERTIFY:
        return '已认证';
      default:
        return '';
    }
  }

  static getStateColorEnum(int status) {
    switch (status) {
      case NO_CERTIFY:
        return StateColorEnum.STATE_RED;
      case PASS_CERTIFY:
        return StateColorEnum.STATE_GREEN;
      default:
        return StateColorEnum.STATE_BLUE;
    }
  }
}
