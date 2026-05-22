/// 滚动加载下拉刷新列表通用的model
class RefreshListModel<T> {
  int currentPage;
  int pageSize;
  int total;
  int totalPage;
  List<T> list;

  RefreshListModel({
    this.currentPage,
    this.pageSize,
    this.total,
    this.totalPage,
    this.list,
  });

  factory RefreshListModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) =>
      RefreshListModel(
        currentPage: json["currentPage"] ?? 0,
        totalPage: json["totalPage"] ?? 0,
        pageSize: json["pageSize"] ?? 0,
        total: json["total"] ?? 0,
        list: ((json["list"] as List<dynamic>)
                ?.map((item) => fromJsonT((item as Map<String, dynamic>)))
                ?.toList() ??
            []),
      );
}
