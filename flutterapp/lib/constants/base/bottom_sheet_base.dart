import 'package:flutter_proj/models/widget/bottom_list_model.dart';

abstract class BottomSheetBase {
  String getSheetItemName(dynamic key);

  List<BottomListModel> getSheetModelList(List<dynamic> keys) {
    return keys.map((key) {
      return BottomListModel(id: key, name: getSheetItemName(key), isSelected: false);
    }).toList();
  }

  List<String> getSheetNames(List<dynamic> keys) {
    return getSheetModelList(keys).map((e) => e.name).toList();
  }

  List<BottomListModel> get sheetModelList;

  List<String> get sheetNames;
}
