import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_proj/utils/async_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class XtmFilePicker {
  XtmFilePicker() {}

  Future<String> pickFile({maxSize = 100}) {
    return pickFileHandler(
      maxSize: maxSize,
    );
  }

  Future<String> pickFileHandler({
    maxSize,
  }) {
    return AsyncUtils.PromiseFunction<String>((promise) async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx', 'xls', 'xlsx', 'pdf'],
      );
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path;
        String extension = filePath.split('.').last.toLowerCase();
        if (!['doc', 'docx', 'xls', 'xlsx', 'pdf'].contains(extension)) {
          XtmToast.warn('不支持此文件类型');
          return;
        }
        File file = File(filePath);
        final bytes = file.readAsBytesSync().lengthInBytes;
        final kb = bytes / 1024;
        final mb = kb / 1024;
        if (mb > maxSize) {
          XtmToast.warn('文件过大,请重新获取');
        } else {
          promise.complete(filePath);
        }
      }
    });
  }
}

var xtmFilePicker = XtmFilePicker();
