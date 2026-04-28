class MessageListModel {
  List<MessageModel> list;
  var total;
  var pageSize;
  var currentPage;
  var totalPage;

  MessageListModel({this.list, this.total, this.pageSize, this.currentPage, this.totalPage});

  MessageListModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(new MessageModel.fromJson(v));
      });
    }
    total = json['total'];
    pageSize = json['pageSize'];
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['pageSize'] = this.pageSize;
    data['currentPage'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    return data;
  }
}

class MessageModel {
  /// 事件名称
  String eventName;
  String id;

  /// 创建时间
  String createTime;

  /// 类型
  int type;

  /// 0:未读， 1：已读
  int isReaded;

  /// 业务id
  String busiId;

  /// 消息内容
  String msgContent;

  /// app跳转地址
  String appHref;

  /// 子类型
  int childType;

  /// 跳转地址
  String jumpUrl;

  /// 是否可跳转
  bool isJump;

  /// 是否新方法
  bool isNewMethod;

  /// 扩展字段
  MsgExtModel msgExt;
  // 客服消息未读数量
  int onlineCustomerCount;

  MessageModel({
    this.eventName,
    this.id,
    this.type,
    this.isReaded,
    this.busiId,
    this.msgContent,
    this.appHref,
    this.childType,
    this.jumpUrl,
    this.isJump,
    this.isNewMethod,
    this.msgExt,
    this.onlineCustomerCount,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    eventName = json['eventName'];
    id = json['id'];
    createTime = json['createTime'];
    type = json['type'];
    isReaded = json['isReaded'];
    busiId = json['busiId'];
    msgContent = json['msgContent'];
    appHref = json['appHref'];
    childType = json['childType'];
    jumpUrl = json['jumpUrl'];
    isJump = json['isJump'];
    isNewMethod = json['isNewMethod'];
    msgExt = json['msgExt'] != null ? new MsgExtModel.fromJson(json['msgExt']) : null;
    onlineCustomerCount = json['onlineCustomerCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['type'] = this.type;
    data['isReaded'] = this.isReaded;
    data['busiId'] = this.busiId;
    data['msgContent'] = this.msgContent;
    data['appHref'] = this.appHref;
    data['eventName'] = this.eventName;
    data['childType'] = this.childType;
    data['jumpUrl'] = this.jumpUrl;
    data['isJump'] = this.isJump;
    data['isNewMethod'] = this.isNewMethod;
    if (this.msgExt != null) {
      data['msgExt'] = this.msgExt.toJson();
    }
    data['onlineCustomerCount'] = this.onlineCustomerCount;
    return data;
  }
}

/// 消息扩展字段
class MsgExtModel {
  int messageRecordOrigin;

  MsgExtModel.fromJson(Map<String, dynamic> json) {
    messageRecordOrigin = json['messageRecordOrigin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageRecordOrigin'] = this.messageRecordOrigin;
    return data;
  }
}
