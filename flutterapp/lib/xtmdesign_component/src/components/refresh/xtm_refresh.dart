import 'package:flutter/cupertino.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// [XtmRefresh] 刷新组件
///
/// 使用时 传入列表布局以及列表数量，
/// 自行实现刷新和加载更多的回调，
/// 支持自定义空布局UI；
/// 支持传入刷新控制器和单次请求的数据自动处理刷新状态
///
/// 示例：
/// ```
///  XtmRefresh.buildRefresh(
///    listView: _buildListView(),
///    listCount: _bills.length,
///    controller: _orderController,
///    onRefresh: () async {
///      _refreshLList();
///    },
///    onLoading: () async {
///      _getBillList();
///    },
///  )
/// ```

class XtmRefresh {
  static Widget buildRefresh({
    /// 刷新控制器
    @required RefreshController controller,

    /// ListView, 子 view 必须是 ListView
    @required Widget listView,

    /// 列表数量
    @required int listCount,

    /// 刷新回调
    @required VoidCallback onRefresh,

    /// 加载更多回调
    @required VoidCallback onLoading,

    /// 是否允许上拉加载
    bool enablePullUp = true,

    /// 自定义空视图
    Widget emptyView,
  }) {
    return SmartRefresher(
      child: listCount == 0 ? (emptyView ?? XtmEmptyView()) : listView,
      controller: controller,
      enablePullUp: enablePullUp,
      onRefresh: onRefresh,
      onLoading: onLoading,
    );
  }

  /// 处理刷新状态
  /// data 本次请求结果集
  static void handleRefreshState(RefreshController controller, List<dynamic> data) {
    if (controller.isRefresh) {
      controller.refreshCompleted(resetFooterState: true);
    }
    if (controller.isLoading) {
      controller.loadComplete();
    }
    if (data.isEmpty || data.length < 10) {
      controller.loadNoData();
    }
  }

  /// 重置状态
  static void resetRefresh(RefreshController controller) {
    controller.refreshCompleted();
    controller.loadComplete();
  }
}
