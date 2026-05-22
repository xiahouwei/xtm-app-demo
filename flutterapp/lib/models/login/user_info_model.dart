class UserInfoModel {
  ///审核状态，0待审核 1审核通过 2审核驳回
  int auditStatus;

  ///用户Id
  String userID;

  /// 是否初始密码
  bool initPassword;

  ///手机号
  String mobile;

  ///姓名
  String userName;

  /// 用户头像
  String portraitPhotoUrl;

  /// 身份证号
  String idNumber;

  /// 车辆经营人 1是 0否
  int isVehicleOperator;

  /// 车辆经营人id
  int vehicleOperatorId;

  ///公司信息
  CompanyInfo companyInfo;

  UserInfoModel({
    this.auditStatus,
    this.userID,
    this.initPassword,
    this.mobile,
    this.userName,
    this.portraitPhotoUrl,
    this.idNumber,
    this.companyInfo,
    this.isVehicleOperator,
    this.vehicleOperatorId,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
      auditStatus: json["auditStatus"],
      userID: json["userID"],
      initPassword: json["initPassword"],
      mobile: json["mobile"],
      userName: json["userName"],
      portraitPhotoUrl: json['portraitPhotoUrl'],
      idNumber: json['idNumber'],
      companyInfo: json["companyInfo"] != null
          ? CompanyInfo.fromJson(json["companyInfo"])
          : null,
      isVehicleOperator: json["isVehicleOperator"],
      vehicleOperatorId: json["vehicleOperatorId"]);

  Map<String, dynamic> toJson() => {
        "auditStatus": auditStatus,
        "userID": userID,
        "initPassword": initPassword,
        "mobile": mobile,
        "userName": userName,
        "portraitPhotoUrl": portraitPhotoUrl,
        "idNumber": idNumber,
        "companyInfo": companyInfo,
        "isVehicleOperator": isVehicleOperator,
        "vehicleOperatorId": vehicleOperatorId,
      };
}

class CompanyInfo {
  ///公司id
  String companyID;

  ///公司名称
  String companyName;

  /// 角色类型
  List organTypeIds;
  String companyAgentId;

  /// 企业代理编码
  String companyAgentCode;

  /// 认证状态 0未认证 1已认证
  int certificationStatus;

  /// 统一社会信用代码
  String unifiedSocialCreditIdentifier;

  CompanyInfo({
    this.companyID,
    this.companyName,
    this.organTypeIds,
    this.companyAgentId,
    this.companyAgentCode,
    this.certificationStatus,
    this.unifiedSocialCreditIdentifier,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
        companyID: json["companyID"],
        companyName: json["companyName"],
        organTypeIds: json['organTypeIds'],
        companyAgentId: json['companyAgentId'],
        companyAgentCode: json['companyAgentCode'],
        certificationStatus: json['certificationStatus'],
        unifiedSocialCreditIdentifier: json['unifiedSocialCreditIdentifier'],
      );

  Map<String, dynamic> toJson() => {
        "companyID": companyID,
        "companyName": companyName,
        "organTypeIds": organTypeIds,
        "companyAgentId": companyAgentId,
        "companyAgentCode": companyAgentCode,
        "certificationStatus": certificationStatus,
        "unifiedSocialCreditIdentifier": unifiedSocialCreditIdentifier,
      };
}
