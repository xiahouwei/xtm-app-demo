import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/bottom_sheet/widgets/bottom_sheet_header.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/bottom_sheet/widgets/custom_picker.dart';
import 'package:flutter_proj/xtmdesign_component/src/constants/area_constants.dart';

import 'province_model.dart';

class XtmCityPicker {
  static showCityPicker(
    BuildContext context, {
    String selectItem,
    String title = '请选择地区',
    double height = 250.0,
    bool isDismissible = true,
    Function(ProvinceModel province, CityModel city, CountryModel country) onSelected,
  }) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      builder: (ctx) {
        return _XtmCityPickerContent(
          title: title,
          onSelected: onSelected,
        );
      },
    );
  }
}

class _XtmCityPickerContent extends StatefulWidget {
  /// 标题
  final String title;
  final Function(
    ProvinceModel province,
    CityModel city,
    CountryModel country,
  ) onSelected;

  _XtmCityPickerContent({
    this.title,
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
      height: 250.0,
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
            confirmAction: () {
              widget.onSelected(
                ProvinceModel(
                  provinceID: provinces[_selectedProvinceIndex].provinceID,
                  provinceName: provinces[_selectedProvinceIndex].provinceName,
                ),
                CityModel(
                  cityID: cities[_selectedCityIndex].cityID,
                  cityName: cities[_selectedCityIndex].cityName,
                ),
                CountryModel(
                  countryID: countries[_selectedCountryIndex].countryID,
                  countryName: countries[_selectedCountryIndex].countryName,
                ),
              );
              Navigator.of(context).pop();
            },
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
}
