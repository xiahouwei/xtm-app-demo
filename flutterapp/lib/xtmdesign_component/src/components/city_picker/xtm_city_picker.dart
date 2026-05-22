import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/bottom_sheet/widgets/bottom_sheet_header.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/bottom_sheet/widgets/custom_picker.dart';
import 'package:flutter_proj/xtmdesign_component/src/constants/area_constants.dart';

import 'province_model.dart';

/// 城市选择器工具类，用于展示省市区三级联动的底部弹窗。
///
/// [XtmCityPicker] 封装了 [showModalBottomSheet]，
/// 提供标准的省市区滚动选择交互，并在用户点击确认后通过回调返回选中的数据模型。
///
/// 示例：
/// ```dart
/// XtmCityPicker.showCityPicker(
///   context,
///   title: '选择收货地址',
///   onSelected: (province, city, country, areaCode) {
///     print('选中地区:  $ {province.provinceName}  $ {city.cityName}  $ {country.countryName}');
///     print('地区编码:  $ areaCode');
///   },
/// )
/// ```
class XtmCityPicker {
  static showCityPicker(
    BuildContext context, {
    String selectItem,
    String title = '请选择地区',
    double height = 300.0,
    bool isDismissible = true,
    Function(ProvinceModel province, CityModel city, CountryModel country, int areaCode) onSelected,
  }) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      builder: (ctx) {
        return _XtmCityPickerContent(
          title: title,
          height: height,
          onSelected: onSelected,
        );
      },
    );
  }
}

/// 显示城市选择器底部弹窗。
///
/// [context] 为构建上下文。
/// [selectItem] 预留参数，可用于设置默认选中项（当前版本未完全实现）。
/// [title] 弹窗标题，默认为 '请选择地区'。
/// [height] 弹窗高度，默认为 300.0。
/// [isDismissible] 是否允许点击背景关闭弹窗，默认为 true。
/// [onSelected] 确认选择后的回调，返回省份、城市、区县模型及地区编码。
class _XtmCityPickerContent extends StatefulWidget {
  /// 标题
  final String title;
  final double height;
  final Function(
    ProvinceModel province,
    CityModel city,
    CountryModel country,
    int areaCode,
  ) onSelected;

  _XtmCityPickerContent({
    this.title,
    this.height,
    this.onSelected,
  });

  @override
  State<_XtmCityPickerContent> createState() => _XtmCityPickerState();
}

class _XtmCityPickerState extends State<_XtmCityPickerContent> {
  /// 省份
  List<ProvinceModel> provinces;
  List<String> _provinceNames = [];

  ///  城市
  List<CityModel> cities;
  List<String> _cityNames = [];

  /// 区县
  List<CountryModel> countries;
  List<String> _countryNames = [];

  int _selectedProvinceIndex = 0;
  int _selectedCityIndex = 0;
  int _selectedCountryIndex = 0;

  FixedExtentScrollController _cityScrollController;
  FixedExtentScrollController _countryScrollController;

  @override
  void initState() {
    super.initState();
    initAreaData();
  }

  void initAreaData() {
    _cityScrollController = FixedExtentScrollController(initialItem: _selectedCityIndex);
    _countryScrollController = FixedExtentScrollController(initialItem: _selectedCountryIndex);

    List<Map<String, dynamic>> areaData = AreaConstants.provinceList;

    provinces = areaData.map((e) => ProvinceModel.fromJson(e)).toList();
    _provinceNames = provinces.map((e) => e.provinceName).toList();

    cities = provinces[_selectedProvinceIndex].city;
    _cityNames = cities.map((e) => e.cityName).toList();

    countries = cities[_selectedCityIndex].county;
    _countryNames = countries.map((e) => e.countryName).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(12.0),
          right: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(
            title: widget.title,
            confirmAction: () => _onConfirm(),
          ),
          _buildHorizontalDivider(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CustomPicker(
                    data: _provinceNames,
                    selectedIndex: _selectedProvinceIndex,
                    onSelectedItemChanged: (index) {
                      _selectedProvinceIndex = index;
                      refreshCity();
                    },
                  ),
                ),
                Expanded(
                  child: CustomPicker(
                    data: _cityNames,
                    scrollController: _cityScrollController,
                    selectedIndex: _selectedCityIndex,
                    onSelectedItemChanged: (index) {
                      _selectedCityIndex = index;
                      refreshCountry();
                    },
                  ),
                ),
                Expanded(
                  child: CustomPicker(
                    data: _countryNames,
                    scrollController: _countryScrollController,
                    selectedIndex: _selectedCountryIndex,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedCountryIndex = index;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHorizontalDivider() {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Color(0xFFE8E8E8),
    );
  }

  void refreshCity() {
    setState(() {
      cities = provinces[_selectedProvinceIndex].city;
      _cityNames.clear();
      _cityNames.addAll(cities.isEmpty ? [] : cities.map((e) => e.cityName).toList());
      _selectedCityIndex = 0;
      _cityScrollController.jumpToItem(_selectedCityIndex);
      countries = cities.isEmpty ? [] : cities[_selectedCityIndex].county;
      _countryNames.clear();
      _countryNames.addAll(countries.isEmpty ? [] : countries.map((e) => e.countryName).toList());
      _selectedCountryIndex = 0;
    });
  }

  void refreshCountry() {
    setState(() {
      countries = cities[_selectedCityIndex].county;
      _countryNames.clear();
      _countryNames.addAll(countries.isEmpty ? [] : countries.map((e) => e.countryName).toList());
      _selectedCountryIndex = 0;
      _countryScrollController.jumpToItem(_selectedCountryIndex);
    });
  }

  void _onConfirm() {
    ProvinceModel province = ProvinceModel(
      provinceID: provinces[_selectedProvinceIndex].provinceID,
      provinceName: provinces[_selectedProvinceIndex].provinceName,
    );
    CityModel city = CityModel(
      cityID: cities.isNotEmpty ? cities[_selectedCityIndex].cityID : 0,
      cityName: cities.isNotEmpty ? cities[_selectedCityIndex].cityName : '',
    );
    CountryModel country = CountryModel(
      countryID: countries.isNotEmpty ? countries[_selectedCountryIndex].countryID : 0,
      countryName: countries.isNotEmpty ? countries[_selectedCountryIndex].countryName : '',
    );
    int _areaCode;
    if (country.countryID > 0) {
      _areaCode = country.countryID;
    } else if (city.cityID > 0) {
      _areaCode = city.cityID;
    } else {
      _areaCode = province.provinceID;
    }
    widget.onSelected(province, city, country, _areaCode);
    Navigator.of(context).pop();
  }
}
