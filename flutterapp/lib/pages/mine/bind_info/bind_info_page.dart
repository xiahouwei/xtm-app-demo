import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/models/mine/bind_info_model.dart';
import 'package:flutter_proj/pages/mine/bind_info/widgets/company_item.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class BindInfoPage extends StatefulWidget {
  @override
  State<BindInfoPage> createState() => _BindInfoPageState();
}

class _BindInfoPageState extends State<BindInfoPage> {
  List<BindInfoModel> infoList = [];

  @override
  void initState() {
    super.initState();
    getInfoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XtmColor.bgColor,
      appBar: XtmAppBar(title: '绑定信息'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('您当前已被${infoList.length}家公司绑定'),
            SizedBox(height: 15),
            Expanded(
              child: infoList.length == 0
                  ? XtmEmptyView()
                  : ListView.separated(
                      itemCount: infoList.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return CompanyItem(bindInfo: infoList[index]);
                      }),
            )
          ],
        ),
      ),
    );
  }

  void getInfoList() {
    xtmApi.mine.bindInfoList().then((res) {
      List data = res;
      if (data.isEmpty) {
        return;
      }
      data.map((item) {
        infoList.add(BindInfoModel.fromJson(item));
      }).toList();
      setState(() {});
    });
  }
}
