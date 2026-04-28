import 'package:flutter_proj/device/device_recoder.dart';
import 'package:flutter_proj/device/device_image_picker.dart';
import 'package:flutter_proj/device/device_file_picker.dart';
import 'package:flutter_proj/device/device_permission.dart';
import 'package:flutter_proj/device/device_info.dart';
import 'package:flutter_proj/device/device_phone.dart';
import 'package:flutter_proj/device/device_llocation.dart';

class Device {
  Device._internal();

  static final Device _singleton = Device._internal();

  factory Device() => _singleton;

  XtmRecord get record => xtmRecord;

  XtmImagePicker get imagePicker => xtmImagePicker;

  XtmFilePicker get filePicker => xtmFilePicker;

  XtmPermissionHandler get permission => xtmPermission;

  XtmDeviceInfo get deviceInfo => xtmDeviceInfo;

  XtmPhone get phone => xtmPhone;

  XtmLocation get location => xtmLocation;
}

var xtmDevice = Device();
