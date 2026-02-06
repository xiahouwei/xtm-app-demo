import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// [XtmNetImage] 网络图片加载展示
/// 带有进度显示的网络图片加载组件，支持自定义占位图，错误处理，
/// 支持传入 token 字段，自动加载到请求头中，字段为 'Authorization'
///
/// 示例：
/// ```
///  XtmNetImage.network(
///    imgUrl: imgUrl ?? (imgId != null && imgId.isNotEmpty) ? _getImageSrcById(imgId) : '',
///    token: xtmGlobalStore.auth.token ?? '',
///    width: width,
///    height: height,
///    fit: fit,
///    placeholderPath: ImageConstants.getPlaceholderImagePath(placeholderType),
///    errorBuilder: errorBuilder,
///  );
/// ```

class XtmNetImage {
  static Widget network({
    String imgUrl,
    String token,
    double width,
    double height,
    BoxFit fit,
    String placeholderPath,
    Widget Function(BuildContext, Object, StackTrace) errorBuilder,
  }) {
    return Image(
      image: _XTMNetworkImager(imgUrl, token: token),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder ??
          (_, __, ___) {
            return Image.asset(
              placeholderPath ?? 'lib/xtmdesign_component/assets/images/img_placeholder.png',
              width: width,
              height: height,
              fit: BoxFit.fill,
            );
          },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          width: width,
          height: height,
          color: Colors.blue.withOpacity(0.1),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[300],
              color: xtmDesignConfig.mainColor,
              strokeWidth: 2,
              value: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes,
            ),
          ),
        );
      },
    );
  }
}

class _XTMNetworkImager extends ImageProvider<_XTMNetworkImager> {
  final String url;
  final double scale;
  final String token;

  _XTMNetworkImager(this.url, {this.token = '', this.scale = 1.0});

  @override
  Future<_XTMNetworkImager> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_XTMNetworkImager>(this);
  }

  @override
  ImageStreamCompleter load(_XTMNetworkImager key, DecoderCallback decode) {
    final NetworkImage networkImage = NetworkImage(
      url,
      scale: scale,
      headers: {
        'Authorization': token,
      },
    );
    return networkImage.load(networkImage, decode);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _XTMNetworkImager && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => ui.hashValues(url, scale);

  @override
  String toString() => '${objectRuntimeType(this, 'XTMNetworkImager')}("$url", scale: $scale)';
}
