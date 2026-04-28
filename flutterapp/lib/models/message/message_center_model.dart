class MessageCenterListModel {
  List<MessageCenterModel> dataArr;

  MessageCenterListModel({this.dataArr});

  MessageCenterListModel.fromJson(Map<String, dynamic> json) {
    if (json['dataArr'] != null) {
      dataArr = [];
      json['dataArr'].forEach((v) {
        dataArr.add(new MessageCenterModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataArr != null) {
      data['dataArr'] = this.dataArr.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageCenterModel {
  /// 消息类型
  int type;
  /// 消息统计信息
  DetailMessageBoModel detailMessageBo;

  MessageCenterModel({this.type, this.detailMessageBo});

  MessageCenterModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    detailMessageBo = json['detailMessageBo'] != null
        ? new DetailMessageBoModel.fromJson(json['detailMessageBo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.detailMessageBo != null) {
      data['detailMessageBo'] = this.detailMessageBo.toJson();
    }
    return data;
  }
}

class DetailMessageBoModel {
  /// 消息数量
  int value;
  /// 最后发送时间
  String maxTime;
  /// 最新消息明细
  String msgContent;

  DetailMessageBoModel({this.value, this.msgContent, this.maxTime});

  DetailMessageBoModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    msgContent = json['msgContent'];
    maxTime = json['maxTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['msgContent'] = this.msgContent;
    data['maxTime'] = this.maxTime;
    return data;
  }
}
