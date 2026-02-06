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
  final BoxFit fit;
  final ImageTypeEnum placeholderType;
  final Widget Function(BuildContext, Object, StackTrace) errorBuilder;

  DisplayImage({
    Key key,
    this.imgId,
    this.imgUrl,
    this.width,
    this.height,
    this.fit = BoxFit.fitWidth,
    this.placeholderType,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return XtmNetImage.network(
      imgUrl: imgUrl ?? (imgId != null && imgId.isNotEmpty) ? _getImageSrcById(imgId) : '',
      token: xtmGlobalStore.auth.token ?? '',
      width: width,
      height: height,
      fit: fit,
      placeholderPath: ImageConstants.getPlaceholderImagePath(placeholderType),
      errorBuilder: errorBuilder,
    );
  }

  /// 通过图片id获取图片url
  static String _getImageSrcById(String id) {
    String imageSrc = '';
    if (id != null && id.isNotEmpty) {
      imageSrc = HTTPConfig.serverDomain + '/api/file/downLoad/$id';
    }
    return imageSrc;
  }
}
