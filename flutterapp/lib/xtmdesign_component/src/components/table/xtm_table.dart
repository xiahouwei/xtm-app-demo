import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../utils/xtm_scroll_sync_utils.dart';
import '../empty_view/xtm_empty.dart';

/// 表格列的数据模型。
///
/// 用于定义 [XtmTable] 中每一列的字段名、显示名称、宽度以及是否参与合计。
class XtmTableColumModel {
  ///字段
  String field;

  ///名称
  String label;

  ///是否合计 0:不合计 1:合计
  int totalFlag;

  /// 列宽度
  num width;

  XtmTableColumModel({
    this.field,
    this.label,
    this.totalFlag,
    this.width = 100,
  });
}

/// 多功能数据表格组件。
///
/// [XtmTable] 提供了一个带有固定表头和底部合计行的横向滚动表格。
/// 组件内部自动添加了“序号”列，并实现了表头、表体、合计行三部分的横向滚动同步。
/// 当列的 [totalFlag] 设置为 1 时，底部会自动计算并显示该列的数值总和。
///
/// 示例：
/// ```dart
/// XtmTable(
///   columns: [
///     XtmTableColumModel(field: 'productName', label: '商品名称', width: 150),
///     XtmTableColumModel(field: 'price', label: '单价', width: 100, totalFlag: 1),
///     XtmTableColumModel(field: 'count', label: '数量', width: 100, totalFlag: 1),
///   ],
///   tableData: [
///     {'productName': '商品A', 'price': '10.5', 'count': '2'},
///     {'productName': '商品B', 'price': '20.0', 'count': '3'},
///   ],
/// )
/// ```
class XtmTable extends StatefulWidget {
  /// 表格的数据源
  final List<Map<String, dynamic>> tableData;

  /// 表格的列定义
  final List<XtmTableColumModel> columns;

  XtmTable({
    Key key,
    this.tableData = const [],
    this.columns,
  }) : super(key: key);

  @override
  State<XtmTable> createState() => _XtmTableState();
}

class _XtmTableState extends State<XtmTable> {
  final ScrollController _headerController = ScrollController();
  final ScrollController _bodyController = ScrollController();
  final ScrollController _bottomController = ScrollController();
  final XtmScrollSyncUtils scrollSyncInstance = XtmScrollSyncUtils();

  @override
  void initState() {
    super.initState();
    initScrollEvent();
  }

  void initScrollEvent() {
    scrollSyncInstance.bindScrollSync([_headerController, _bodyController, _bottomController]);
  }

  @override
  Widget build(BuildContext context) {
    return _buildReportTable();
  }

  Widget _buildReportTable() {
    XtmTableColumModel indexCol = XtmTableColumModel(label: '序号', width: 60);
    List<XtmTableColumModel> columns = [indexCol, ...widget.columns];
    List<Map<String, dynamic>> rows = widget.tableData;
    final double totalTableWidth = columns.fold(0, (sum, item) {
      return sum + item.width.toDouble();
    });
    bool showTotalRow = widget.columns.any((item) => item.totalFlag == 1);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            border: Border(
              top: BorderSide(color: Color(0xFFE0E0E0)),
              bottom: BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          child: SingleChildScrollView(
            controller: _headerController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalTableWidth,
              height: 40,
              child: Row(
                children: List.generate(columns.length, (index) {
                  return Container(
                    width: columns[index].width.toDouble(),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                    child: Text(
                      columns[index].label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF606266),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _bodyController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalTableWidth,
              child: rows.length == 0
                  ? XtmEmptyView()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 40,
                          color: index % 2 == 0 ? Colors.white : Color(0xFFFAFAFA),
                          child: Row(
                            children: List.generate(columns.length, (colIndex) {
                              String cellValue = '';
                              if (colIndex == 0) {
                                cellValue = '${index + 1}';
                              } else {
                                cellValue = rows[index][columns[colIndex].field]?.toString() ?? '';
                              }
                              return Container(
                                width: columns[colIndex].width.toDouble(),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Color(0xFFF0F0F0)),
                                    bottom: BorderSide(color: Color(0xFFF0F0F0)),
                                  ),
                                ),
                                child: Text(
                                  cellValue,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF606266),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
        if (showTotalRow)
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border(
                top: BorderSide(color: Color(0xFFE0E0E0)),
                bottom: BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
            child: SingleChildScrollView(
              controller: _bottomController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalTableWidth,
                height: 40,
                child: Row(
                  children: List.generate(columns.length, (index) {
                    String totalText = '';
                    if (index == 0) {
                      totalText = '合计';
                    } else if (columns[index].totalFlag == 1) {
                      final Decimal total = rows.fold<Decimal>(Decimal.zero, (sum, item) {
                        final value = Decimal.tryParse(
                              item[columns[index].field]?.toString() ?? '0',
                            ) ??
                            Decimal.zero;
                        return sum + value;
                      });
                      totalText = total.toString();
                    }
                    return Container(
                      width: columns[index].width.toDouble(),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ),
                      child: Text(
                        totalText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF606266),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _headerController.dispose();
    _bodyController.dispose();
    _bottomController.dispose();
    super.dispose();
  }
}
