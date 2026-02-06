import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/images/xtm_net_image.dart';
import 'package:flutter_proj/xtmdesign_component/src/xtm_design_config.dart';
import 'package:flutter_proj/device/index.dart';

/// [XtmImagePicker] 图片选择器
///
/// 支持拍照和从相册选择两种方式获取照片，也可设置仅拍照 [onlyCamera],
/// 支持自定义宽高和填充方式，支持设置占位图，支持自定义图片加载错误处理 [errorBuilder]；
/// 支持必选标识，和图片说明[imgDesc], 支持网络图片 header 中加 token，字段为 'Authorization'
///
/// 示例：
/// ```
///  XtmImagePicker(
///    imgUrl: _getImageUrlById(widget.imgId),
///    token: xtmGlobalStore.auth.token ?? '',
///    fit: widget.fit,
///    width: widget.width,
///    height: widget.height,
///    isRequired: widget.isRequired,
///    imgDesc: widget.imgDesc,
///    placeholderPath: ImageConstants.getPlaceholderImagePath(widget.imageType),
///    errorBuilder: widget.errorBuilder,
///    onImageSelected: (imagePath) {
///      _uploadImage(imagePath);
///    },
///  )
/// ```

class XtmImagePicker extends StatefulWidget {
  final String imgUrl;
  final String token;
  final BoxFit fit;
  final double width;
  final double height;
  final bool isRequired;
  final String imgDesc;
  final String placeholderPath;
  final bool onlyCamera;
  final Widget Function(BuildContext, Object, StackTrace) errorBuilder;
  final ValueChanged<String> onImageSelected;

  XtmImagePicker({
    Key key,
    this.imgUrl,
    this.token,
    this.fit = BoxFit.fitWidth,
    this.width = 80,
    this.height = 60,
    this.isRequired = false,
    this.imgDesc = '请上传图片',
    this.placeholderPath,
    this.errorBuilder,
    this.onImageSelected,
    this.onlyCamera = false,
  }) : super(key: key);

  @override
  State<XtmImagePicker> createState() => _XtmImagePickerState();
}

class _XtmImagePickerState extends State<XtmImagePicker> {
  String imgPath = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showImage(),
            SizedBox(
              width: widget.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: widget.isRequired,
                    child: Text('*',
                        strutStyle: StrutStyle(height: 2, leading: 0.0, forceStrutHeight: true),
                        style: TextStyle(color: Colors.red)),
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.imgDesc,
                    style: TextStyle(
                      fontSize: 13,
                      color: xtmDesignConfig.mainTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        FocusScope.of(context).unfocus();
        widget.onlyCamera ? openCamera() : _selectResource();
      },
    );
  }

  Widget showImage() {
    if (widget.imgUrl != null && widget.imgUrl.isNotEmpty) {
      return XtmNetImage.network(
          imgUrl: widget.imgUrl,
          token: widget.token,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          placeholderPath: widget.placeholderPath,
          errorBuilder: widget.errorBuilder);
    }
    return Image.file(
      File(imgPath),
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      errorBuilder: widget.errorBuilder ??
          (context, error, stackTrace) {
            return Image.asset(
              widget.placeholderPath ?? 'lib/xtmdesign_component/assets/images/img_placeholder.png',
              width: widget.width,
              height: widget.height,
              fit: BoxFit.fill,
            );
          },
    );
  }

  void _selectResource() {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          //设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(textScaleFactor: xtmDesignConfig.fontScale),
          child: CupertinoActionSheet(
            title: const Text(
              '获取图片',
              style: TextStyle(fontSize: 19, color: Colors.black54),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('拍照'),
                onPressed: () {
                  Navigator.pop(context, 'Camera');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('相册'),
                onPressed: () {
                  Navigator.pop(context, 'Gallery');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('取消'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ),
        );
      },
    ).then((String value) {
      if (value != null) {
        if (value == "Camera") {
          openCamera();
        } else if (value == "Gallery") {
          xtmDevice.imagePicker.getImageByGallery().then((value) {
            widget.onImageSelected(value);
            setState(() {
              imgPath = value;
            });
          });
        }
      }
    });
  }

  /// 打开相机
  void openCamera() {
    xtmDevice.imagePicker.getImageByCamera().then((value) {
      widget.onImageSelected(value);
      setState(() {
        imgPath = value;
      });
    });
  }
}
