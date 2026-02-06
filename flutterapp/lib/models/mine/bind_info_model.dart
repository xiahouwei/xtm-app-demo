class BindInfoModel {
  ///审核状态 0: 待审核 1: 审核通过 2：审核不通过
  int auditStatus;

  ///联系人
  String contact;

  ///主键id
  String id;

  ///邀请码
  String inviteCode;

  ///联系人手机号
  String mobile;

  ///公司名称
  String name;

  ///机构Id
  int organId;

  ///备注
  String remark;

  ///来源 0: 注册 1: 页面新增
  int source;

  ///类型 0: 采购商 1: 供应商 2：承运商
  int type;

  ///统一社会信用代码
  String uscc;

  ///管理员用户id
  int userId;

  BindInfoModel({
    this.auditStatus,
    this.contact,
    this.id,
    this.inviteCode,
    this.mobile,
    this.name,
    this.organId,
    this.remark,
    this.source,
    this.type,
    this.uscc,
    this.userId,
  });

  factory BindInfoModel.fromJson(Map<String, dynamic> json) => BindInfoModel(
        auditStatus: json["auditStatus"],
        contact: json["contact"],
        id: json["id"],
        inviteCode: json["inviteCode"],
        mobile: json["mobile"],
        name: json["name"],
        organId: json["organId"],
        remark: json["remark"],
        source: json["source"],
        type: json["type"],
        uscc: json["uscc"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "auditStatus": auditStatus,
        "contact": contact,
        "id": id,
        "inviteCode": inviteCode,
        "mobile": mobile,
        "name": name,
        "organId": organId,
        "remark": remark,
        "source": source,
        "type": type,
        "uscc": uscc,
        "userId": userId,
      };
}
