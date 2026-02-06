import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/dialog/xtm_confirm_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class XtmPhone {
  XtmPhone._internal();

  static final XtmPhone _singleton = XtmPhone._internal();

  factory XtmPhone() => _singleton;

  void callDialog(BuildContext context, String phoneNumber) {
    XtmConfirmDialog.show(
      context,
      message: '是否拨打 $phoneNumber',
    ).then((value) => _callPhone(phoneNumber));
  }

  Future<void> _callPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '无法拨打电话: $phoneNumber';
    }
  }
}

var xtmPhone = XtmPhone();
