import 'package:flutter/material.dart';
import 'package:flutter_proj/models/widget/address_filter_model.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:provider/provider.dart';

class AddressFilterWidget extends StatefulWidget {
  final ValueChanged<AddressFilterModel> onAddressChanged;
  final AddressFilterModel initModel;

  AddressFilterWidget({
    Key key,
    this.initModel,
    this.onAddressChanged,
  }) : super(key: key);

  @override
  State<AddressFilterWidget> createState() => AddressFilterWidgetState();
}

class AddressFilterWidgetState extends State<AddressFilterWidget> {
  ThemeNotifier _theme;
  AddressFilterModel _addressModel;
  String _sendAddress;
  String _receiveAddress;

  @override
  void initState() {
    super.initState();
    _addressModel = widget.initModel;
    _sendAddress = _addressModel.sendAddress != null && _addressModel.sendAddress.isNotEmpty
        ? _addressModel.sendAddress
        : '请选择发货地';
    _receiveAddress =
        _addressModel.receiveAddress != null && _addressModel.receiveAddress.isNotEmpty
            ? _addressModel.receiveAddress
            : '请选择收货地';
  }

  @override
  Widget build(BuildContext context) {
    _theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('发货地'),
          SizedBox(height: 10),
          InkWell(
            child: _buildAddress(_sendAddress),
            onTap: () {
              XtmCityPicker.showCityPicker(
                context,
                onSelected: (province, city, country, areaCode) {
                  setState(() {
                    _sendAddress = '${province.provinceName}${city.cityName}${country.countryName}';
                  });
                  _addressModel.sendAddress = _sendAddress;
                  _addressModel.sendCode = areaCode;
                  widget.onAddressChanged(_addressModel);
                },
              );
            },
          ),
          SizedBox(height: 20),
          Text('收货地'),
          SizedBox(height: 10),
          InkWell(
            child: _buildAddress(_receiveAddress),
            onTap: () {
              XtmCityPicker.showCityPicker(
                context,
                onSelected: (province, city, country, areaCode) {
                  setState(() {
                    _receiveAddress =
                        '${province.provinceName}${city.cityName}${country.countryName}';
                  });
                  _addressModel.receiveAddress = _receiveAddress;
                  _addressModel.receiveCode = areaCode;
                  widget.onAddressChanged(_addressModel);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(String address) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _theme.unSelectBgColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              address,
              style: TextStyle(
                fontSize: 14,
                color: address.contains('请选择') ? _theme.titleTextColor : _theme.mainTextColor,
              ),
            ),
          ),
          Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    );
  }

  void resetAddress() {
    setState(() {
      _addressModel = AddressFilterModel();
      _sendAddress = '请选择发货地';
      _receiveAddress = '请选择收货地';
    });
  }
}
