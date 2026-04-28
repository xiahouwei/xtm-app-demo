import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_proj/widgets/tms_loading.dart';
import 'package:flutter_proj/utils/async_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

import 'device_permission.dart';

class XtmImagePicker {
  XtmImagePicker._internal();

  static final XtmImagePicker _singleton = XtmImagePicker._internal();

  factory XtmImagePicker() => _singleton;

  /// 如果不需要压缩，可以设置 maxSizeMB = double.infinity
  Future<String> getImageByGallery({maxSizeMB = 5}) async {
    await xtmPermission.requestPhotoAlbumPermission();
    return getImageHandler(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxSize: maxSizeMB,
    );
  }

  Future<String> getImageByCamera({maxSizeMB = 5}) async {
    await xtmPermission.requestCameraPermission();
    return getImageHandler(
      source: ImageSource.camera,
      imageQuality: 100,
      maxSize: maxSizeMB,
    );
  }

  Future<String> getImageHandler({
    ImageSource source,
    int imageQuality,
    maxSize,
  }) {
    return AsyncUtils.PromiseFunction<String>((promise) async {
      File _image;
      ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: imageQuality);
      String path = pickedFile.path;
      _image = File(path);
      final bytes = _image.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      if (mb > maxSize) {
        String compressPath = await compressImage(path);
        promise.complete(compressPath);
      } else {
        promise.complete(path);
      }
    });
  }

  /// 压缩图片
  static Future<String> compressImage(String path,
      {int minSize = 200 * 1024, int maxSize = 5 * 1024 * 1024}) async {
    int minQuality = 10;
    int maxQuality = 95;
    int quality = 80;

    XFile result;
    var dir = await getTemporaryDirectory();
    var targetPath =
        dir.absolute.path + "/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    while (maxQuality - minQuality > 1) {
      result = await FlutterImageCompress.compressAndGetFile(
        path,
        targetPath,
        quality: quality,
        rotate: 0,
      );
      if (result == null) return null;

      /// 图片大小  byte
      int fileSize = await result.length();
      if (fileSize <= maxSize) {
        return result.path;
      }
      if (fileSize > maxSize) {
        maxQuality = quality;
      } else {
        minQuality = quality;
      }
      quality = (minQuality + maxQuality) ~/ 2;
    }
    return result.path;
  }

  Future<String> getVideoByGallery({maxSize = 100}) {
    return getVideoHandler(
      source: ImageSource.gallery,
      maxSize: maxSize,
    );
  }

  Future<String> getVideoHandler({
    ImageSource source,
    maxSize,
  }) {
    return AsyncUtils.PromiseFunction<String>((promise) async {
      File _image;
      ImagePicker picker = ImagePicker();
      final XFile pickedFile = await picker.pickVideo(source: source);
      if (pickedFile == null) return;
      CancelFunc loadingDismiss =
          TmsLoading.showTextLoading('正在压缩视频，请稍等..', dismissByBackButton: true);
      final info = await VideoCompress.compressVideo(
        pickedFile.path,
        quality: VideoQuality.MediumQuality,
        includeAudio: true,
      );
      loadingDismiss();
      if (info == null) return;
      String path = info.path;
      _image = File(path);
      final bytes = _image.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      if (mb > maxSize) {
        XtmToast.warn('视频过大,请重新选择');
      } else {
        promise.complete(path);
      }
    });
  }
}

var xtmImagePicker = XtmImagePicker();
