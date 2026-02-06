class UserPermissionModel {
  UserPermissionModel({
    this.id,
    this.parentId,
    this.name,
    this.type,
    this.path,
    this.code,
    this.perms,
    this.sort,
    this.depth,
    this.redirect,
    this.component,
    this.source,
    this.css,
    this.children,
  });

  String id;
  String parentId;
  String name;
  num type;
  String path;
  String code;

  /// 类型标识 orderManage：订单管理
  String perms;
  num sort;
  num depth;
  String redirect;
  String component;
  num source;
  String css;
  List<ChildrenModel> children;

  UserPermissionModel.fromJson(dynamic json) {
    id = json['id'];
    parentId = json['parentId'];
    name = json['name'];
    type = json['type'];
    path = json['path'];
    code = json['code'];
    perms = json['perms'];
    sort = json['sort'];
    depth = json['depth'];
    redirect = json['redirect'];
    component = json['component'];
    source = json['source'];
    css = json['css'];
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children.add(ChildrenModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['parentId'] = parentId;
    map['name'] = name;
    map['type'] = type;
    map['path'] = path;
    map['code'] = code;
    map['perms'] = perms;
    map['sort'] = sort;
    map['depth'] = depth;
    map['redirect'] = redirect;
    map['component'] = component;
    map['source'] = source;
    map['css'] = css;
    if (children != null) {
      map['children'] = children.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ChildrenModel {
  ChildrenModel({
    this.id,
    this.parentId,
    this.name,
    this.type,
    this.path,
    this.code,
    this.perms,
    this.sort,
    this.depth,
    this.redirect,
    this.component,
    this.source,
    this.css,
    this.children,
  });

  String id;
  String parentId;
  String name;
  num type;
  String path;
  String code;
  String perms;
  num sort;
  num depth;
  String redirect;
  String component;
  num source;
  String css;
  List<ChildrenModel> children;

  ChildrenModel.fromJson(dynamic json) {
    id = json['id'];
    parentId = json['parentId'];
    name = json['name'];
    type = json['type'];
    path = json['path'];
    code = json['code'];
    perms = json['perms'];
    sort = json['sort'];
    depth = json['depth'];
    redirect = json['redirect'];
    component = json['component'];
    source = json['source'];
    css = json['css'];
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children.add(ChildrenModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['parentId'] = parentId;
    map['name'] = name;
    map['type'] = type;
    map['path'] = path;
    map['code'] = code;
    map['perms'] = perms;
    map['sort'] = sort;
    map['depth'] = depth;
    map['redirect'] = redirect;
    map['component'] = component;
    map['source'] = source;
    map['css'] = css;
    if (children != null) {
      map['children'] = children.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
