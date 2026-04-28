class SystemGlobalState {
  /// 字体大小
  double fontScale;

  ///下载进度
  int receiveCount;

  /// im最后更新时间
  String lastChatMessageDatetime;
  SystemGlobalState({
    this.fontScale,
    this.receiveCount,
    this.lastChatMessageDatetime,
  });
}
