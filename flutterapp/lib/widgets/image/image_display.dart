import 'package:flutter/material.dart';
import 'package:flutter_proj/constants/image_constants.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/widgets/image/preview_image_dialog.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class DisplayImage extends StatelessWidget {
  final String imgId;
  final String imgUrl;
  final double width;
  final double height;
  final String imgDesc;
  final BoxFit fit;
  final ImageTypeEnum placeholderType;
  final String errorImgPath;
  final bool isPreview;

  DisplayImage({
    Key key,
    this.imgId,
    this.imgUrl,
    this.width = 80,
    this.height = 60,
    this.imgDesc,
    this.fit = BoxFit.contain,
    this.placeholderType,
    this.errorImgPath,
    this.isPreview = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: XtmNetImage.network(
        imgUrl: imgUrl ?? _getImageSrcById(imgId),
        token: xtmGlobalStore.auth.token ?? '',
        width: width,
        height: height,
        imgDesc: imgDesc,
        fit: fit,
        placeholderPath: ImageConstants.getPlaceholderImagePath(placeholderType),
        errorImgPath: errorImgPath,
      ),
      onTap: (isPreview && imgId != null)
          ? () => PreviewImageDialog.show(context, imgId: imgId, imgUrl: imgUrl)
          : null,
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
