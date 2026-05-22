/// 用户可管理企业model
class UserCompanyModel {
  String id;
  String name;
  UserCompanyModel({
    this.id,
    this.name,
  });
  factory UserCompanyModel.fromJson(Map<String, dynamic> json) => UserCompanyModel(
        id: json["id"],
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class UserCompanyListModel {
  List<UserCompanyModel> list;

  UserCompanyListModel({
    this.list,
  });

  factory UserCompanyListModel.fromJson(Map<String, dynamic> json) => UserCompanyListModel(
        list: (json["list"] as List)
                ?.map((item) => UserCompanyModel.fromJson(item as Map<String, dynamic>))
                ?.toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "list": list.map((e) => e.toJson()).toList(),
      };
}
