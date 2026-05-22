import 'package:flutter/material.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:photo_view/photo_view.dart';

class PreviewImageDialog {
  static Future<void> show(
    BuildContext context, {
    String imgId,
    String imgUrl,
    bool barrierDismissible = false,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Expanded(
                child: PhotoView(
                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                  imageProvider: NetworkImage(
                    imgUrl ?? _getImageSrcById(imgId),
                    headers: {'token': xtmGlobalStore.auth.token},
                  ),
                ),
              ),
              InkWell(
                child: Image.asset('assets/images/image/image_close.png', width: 30, height: 30),
                onTap: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: 100)
            ],
          ),
        );
      },
    );
  }

  /// 通过图片id获取图片url
  static String _getImageSrcById(String id) {
    String imageSrc = '';
    if (id != null && id.isNotEmpty) {
      imageSrc = HTTPConfig.serverDomain + '/apiPlat/tms-file/downLoad/$id';
    }
    return imageSrc;
  }
}
