class SystemGlobalState {
  /// 字体大小
  double fontScale;

  ///下载进度
  int receiveCount;

  /// im最后更新时间
  String lastChatMessageDatetime;

  /// 全局金额小数位数
  int moneyDecimal;

  SystemGlobalState({
    this.fontScale,
    this.receiveCount,
    this.lastChatMessageDatetime,
    this.moneyDecimal,
  });
}
