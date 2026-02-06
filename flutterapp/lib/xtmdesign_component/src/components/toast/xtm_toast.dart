import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_proj/widgets/tms_loading.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

enum ToastTypeEnum {
  SUCCESS,
  ERROR,
  WARN,
  INFO,
}

class XtmToast {
  static void success(String message) {
    _buildToast(message, ToastTypeEnum.SUCCESS);
  }

  static void error(String message) {
    _buildToast(message, ToastTypeEnum.ERROR);
  }

  static void warn(String message) {
    _buildToast(message, ToastTypeEnum.WARN);
  }

  static void info(String message) {
    _buildToast(message, ToastTypeEnum.INFO);
  }

  static void _buildToast(String message, ToastTypeEnum toastType) {
    BotToast.showCustomText(
      onlyOne: true,
      toastBuilder: (cancelFunc) {
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _createBgColor(toastType),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIcon(toastType),
                SizedBox(width: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQueryData.fromWindow(window).size.width * 0.7,
                  ),
                  child: Text(
                    message,
                    softWrap: true,
                    style: TextStyle(color: xtmDesignConfig.mainTextColor, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Color _createBgColor(ToastTypeEnum toastType) {
    switch (toastType) {
      case ToastTypeEnum.ERROR:
        return Color(0xFFFBD6D2);
        break;
      case ToastTypeEnum.WARN:
        return Color(0xFFFFE8D7);
        break;
      case ToastTypeEnum.SUCCESS:
        return Color(0xFFDEFCE7);
        break;
      case ToastTypeEnum.INFO:
        return Color(0xFFE7EEFD);
        break;
      default:
        return Color(0xFFE7EEFD);
    }
  }

  static Widget _buildIcon(ToastTypeEnum toastType) {
    switch (toastType) {
      case ToastTypeEnum.SUCCESS:
        return Icon(Icons.check_circle, color: Color(0xFF2FB458), size: 20);
      case ToastTypeEnum.ERROR:
        return Icon(Icons.cancel, color: Color(0xFFE43A2C), size: 20);
      case ToastTypeEnum.WARN:
        return Icon(Icons.error, color: Color(0xFFFF7C0E), size: 25);
      default:
        return SizedBox();
    }
  }
}
