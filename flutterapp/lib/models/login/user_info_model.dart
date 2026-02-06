class UserInfoModel {
  ///审核状态，0待审核 1审核通过 2审核驳回
  int auditStatus;

  ///用户Id
  String id;

  String userID;

  ///身份证号
  String identityCard;

  ///手机号
  String mobile;

  ///姓名
  String name;
  String userName;

  ///公司ID
  String organId;

  ///公司名
  String organName;

  UserInfoModel({
    this.auditStatus,
    this.id,
    this.userID,
    this.identityCard,
    this.mobile,
    this.name,
    this.userName,
    this.organId,
    this.organName,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        auditStatus: json["auditStatus"],
        id: json["id"],
        userID: json["userID"],
        identityCard: json["identityCard"],
        mobile: json["mobile"],
        name: json["name"],
        userName: json["userName"],
        organId: json["organId"],
        organName: json["organName"],
      );

  Map<String, dynamic> toJson() => {
        "auditStatus": auditStatus,
        "id": id,
        "userID": userID,
        "identityCard": identityCard,
        "mobile": mobile,
        "name": name,
        "userName": userName,
        "organId": organId,
        "organName": organName,
      };
}
