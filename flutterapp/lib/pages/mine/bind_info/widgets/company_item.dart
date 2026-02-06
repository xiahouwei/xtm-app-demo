import 'package:flutter/material.dart';
import 'package:flutter_proj/constants/common_constant.dart';
import 'package:flutter_proj/models/mine/bind_info_model.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/device/index.dart';

class CompanyItem extends StatelessWidget {
  final BindInfoModel bindInfo;

  const CompanyItem({Key key, this.bindInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bindInfo.name ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('联系人：'),
                  Expanded(child: Text(bindInfo.contact ?? '')),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      xtmDevice.phone.callDialog(context, bindInfo.mobile);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: [
                        Text(bindInfo.mobile ?? '', style: TextStyle(color: XtmColor.themeColor)),
                        SizedBox(width: 5),
                        Icon(
                          Icons.call,
                          size: 16,
                          color: XtmColor.themeColor,
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Color(0x3DFF7C0E),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Text(CompanyTypeConstant.getCompanyTypeText(bindInfo.type),
                style: TextStyle(color: XtmColor.orange, fontSize: 14)),
          ),
        )
      ],
    );
  }
}
