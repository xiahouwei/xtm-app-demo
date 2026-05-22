class CurrentCompanyModel {
  String id;

  /// 企业名称
  String name;

  /// 认证状态
  String certificationState;

  /// 企业角色
  List<int> organTypeIds;

  /// 企业logo
  String logoPhotoId;

  /// 企业管理员
  String companyAdmin;

  CurrentCompanyModel({
    this.id,
    this.name,
    this.certificationState,
    this.organTypeIds,
    this.logoPhotoId,
    this.companyAdmin,
  });

  factory CurrentCompanyModel.fromJson(Map<String, dynamic> json) {
    return CurrentCompanyModel(
      id: json['id'],
      name: json['name'],
      certificationState: json['certificationState'],
      organTypeIds: json['organTypeIds'] != null
          ? List<int>.from(json['organTypeIds'].map((item) => int.tryParse(item.toString())))
          : [],
      logoPhotoId: json['logoPhotoId'],
      companyAdmin: json['companyAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['certificationState'] = this.certificationState;
    data['organTypeIds'] = this.organTypeIds;
    data['logoPhotoId'] = this.logoPhotoId;
    data['companyAdmin'] = this.companyAdmin;
    return data;
  }
}
