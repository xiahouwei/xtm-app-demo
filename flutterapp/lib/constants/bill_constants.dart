class BillConstants {
  /// 执行状态 -- 待执行
  static const int BILL_EXECUTE_STATUS_WAIT = 1;

  /// 执行状态 -- 执行中
  static const int BILL_EXECUTE_STATUS_EXECUTING = 2;

  /// 执行状态 -- 已完成
  static const int BILL_EXECUTE_STATUS_COMPLETED = 3;

  /// 执行状态 -- 已作废
  static const int BILL_EXECUTE_STATUS_INVALID = 4;
}

class BillTimeConstants {
  /// 今日
  static const int BILL_TODAY = 1;

  /// 近7日
  static const int BILL_SEVEN_DAY = 2;

  /// 7日以上
  static const int BILL_OTHER_DAY = 3;
}

class BillTypeConstants {
  /// 调度类型:1采购
  static const int BILL_TYPE_PURCHASE = 1;

  ///  2销售
  static const int BILL_TYPE_SALE = 2;

  ///  3调拨
  static const int BILL_TYPE_RELOCATION = 3;
}

/// 采购 派车单状态
class PurchaseBillStatus {
  // 未执行
  static const int STATUS_UN_EXECUTE = 1;

  // 已接单
  static const int STATUS_ACCEPTED_ORDER = 2;

  // 录入原发
  static const int STATUS_INPUT_ORIGINAL = 3;

  // 铅封施封
  static const int STATUS_LEAD_SEALING = 4;

  // 收货签到
  static const int STATUS_RECEIPT_CHECK_IN = 5;

  // 收货叫号
  static const int STATUS_RECEIPT_CALL = 6;

  // 收货进厂
  static const int STATUS_RECEIPT_ENTER_FACTORY = 7;

  // 收货一次过磅(毛重)
  static const int STATUS_RECEIPT_FIRST_WEIGHING = 8;

  // 收货确认
  static const int STATUS_RECEIPT_CONFIRM = 9;

  // 收货二次过磅(皮重)
  static const int STATUS_RECEIPT_SECOND_WEIGHING = 10;

  // 收货出厂
  static const int STATUS_RECEIPT_LEAVE_FACTORY = 11;

  // 重车出厂(未完成卸货出厂)
  static const int STATUS_HEAVY_LEAVE_FACTORY = 12;

  // 运单完结(收)
  static const int STATUS_BILL_COMPLETED = 20;

  static String getBillStatus(int status) {
    switch (status) {
      case STATUS_UN_EXECUTE:
        return "未执行";
      case STATUS_ACCEPTED_ORDER:
        return "已接单";
      case STATUS_INPUT_ORIGINAL:
        return "录入原发";
      case STATUS_LEAD_SEALING:
        return "铅封施封";
      case STATUS_RECEIPT_CHECK_IN:
        return "收货签到";
      case STATUS_RECEIPT_CALL:
        return "收货叫号";
      case STATUS_RECEIPT_ENTER_FACTORY:
        return "收货进厂";
      case STATUS_RECEIPT_FIRST_WEIGHING:
        return "收货一次过磅(毛重)";
      case STATUS_RECEIPT_CONFIRM:
        return "收货确认";
      case STATUS_RECEIPT_SECOND_WEIGHING:
        return "收货二次过磅(皮重)";
      case STATUS_RECEIPT_LEAVE_FACTORY:
        return "收货出厂";
      case STATUS_HEAVY_LEAVE_FACTORY:
        return "重车出厂";
      case STATUS_BILL_COMPLETED:
        return "已完成";
      default:
        return "未执行";
    }
  }
}

/// 销售 派车单状态
class SaleBillStatus {
  // 作废
  static const int STATUS_INVALID = 0;

  // 未执行
  static const int STATUS_UN_EXECUTED = 1;

  // 已接单
  static const int STATUS_ACCEPTED_ORDER = 2;

  // 发货签到
  static const int STATUS_CHECK_IN = 3;

  // 发货叫号
  static const int STATUS_CALL = 4;

  // 发货进厂
  static const int STATUS_ENTER_FACTORY = 5;

  // 发货一次过磅(皮重)
  static const int STATUS_FIRST_WEIGHING = 6;

  // 发货确认
  static const int STATUS_CONFIRM = 7;

  // 发货二次过磅
  static const int STATUS_SECOND_WEIGHING = 8;

  // 出厂确认
  static const int STATUS_LEAVE_CONFIRM = 9;

  // 发货出厂
  static const int STATUS_LEAVE_FACTORY = 10;

  // 空车出厂(未拉货出厂)
  static const int STATUS_EMPTY_LEAVE_FACTORY = 11;

  // 运单完结(发)
  static const int STATUS_COMPLETED = 20;

  static String getBillStatus(int status) {
    switch (status) {
      case STATUS_INVALID:
        return "已作废";
      case STATUS_UN_EXECUTED:
        return "未执行";
      case STATUS_ACCEPTED_ORDER:
        return "已接单";
      case STATUS_CHECK_IN:
        return "发货签到";
      case STATUS_CALL:
        return "发货叫号";
      case STATUS_ENTER_FACTORY:
        return "发货进厂";
      case STATUS_FIRST_WEIGHING:
        return "发货一次过磅(皮重)";
      case STATUS_CONFIRM:
        return "发货确认";
      case STATUS_SECOND_WEIGHING:
        return "发货二次过磅";
      case STATUS_LEAVE_CONFIRM:
        return "出厂确认";
      case STATUS_LEAVE_FACTORY:
        return "发货出厂";
      case STATUS_EMPTY_LEAVE_FACTORY:
        return "空车出厂";
      case STATUS_COMPLETED:
        return "已完成";
      default:
        return "未执行";
    }
  }
}
