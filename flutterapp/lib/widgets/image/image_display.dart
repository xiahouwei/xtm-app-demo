import 'package:flutter/material.dart';
import 'package:flutter_proj/constants/image_constants.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return XtmNetImage.network(
      imgUrl: imgUrl ?? ((imgId != null && imgId.isNotEmpty) ? _getImageSrcById(imgId) : ''),
      token: xtmGlobalStore.auth.token ?? '',
      width: width,
      height: height,
      imgDesc: imgDesc,
      fit: fit,
      placeholderPath: ImageConstants.getPlaceholderImagePath(placeholderType),
      errorImgPath: errorImgPath,
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
