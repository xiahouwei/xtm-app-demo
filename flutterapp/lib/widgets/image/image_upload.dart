import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/constants/common_constant.dart';
import 'package:flutter_proj/constants/image_constants.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 图片上传组件
class ImageUpload extends StatefulWidget {
  final String imgId;
  final BoxFit fit;
  final double width;
  final double height;
  final bool isRequired;
  final String imgDesc;
  final ImageTypeEnum imageType;
  final ValueChanged<String> onImageUploaded;
  final bool isOcr;
  final Widget Function(BuildContext, Object, StackTrace) errorBuilder;

  ImageUpload({
    Key key,
    this.imgId,
    this.fit = BoxFit.fitWidth,
    this.width = 108,
    this.height = 68,
    this.isRequired = false,
    this.imgDesc = '上传图片',
    this.imageType,
    this.onImageUploaded,
    this.isOcr = false,
    this.errorBuilder,
  }) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        XtmImagePicker(
          imgUrl: _getImageUrlById(widget.imgId),
          token: xtmGlobalStore.auth.token ?? '',
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          isRequired: widget.isRequired,
          imgDesc: widget.imgDesc,
          placeholderPath: ImageConstants.getPlaceholderImagePath(widget.imageType),
          errorBuilder: widget.errorBuilder,
          onImageSelected: (imagePath) {
            _uploadImage(imagePath);
          },
        ),
        IgnorePointer(
          ignoring: true,
          child: Visibility(
            visible: showError,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: Text(
                    '上传失败,请重试',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 通过图片id获取图片url
  static String _getImageUrlById(String id) {
    String imageSrc = '';
    if (id != null && id.isNotEmpty) {
      imageSrc = HTTPConfig.serverDomain + '/api/file/downLoad/$id';
    }
    return imageSrc;
  }

  /// 上传图片
  void _uploadImage(String imagePath) async {
    await xtmApi.image.uploadFile(imagePath, UploadBusSourceConstant.VEHICLE_MANAGE).then((res) {
      setState(() {
        showError = false;
        widget.onImageUploaded(res['fileId']);
      });
    }).catchError((error) => setState(() => showError = true));
    // 如果开启OCR  进行OCR识别
    if (widget.isOcr) {
      await xtmApi.image
          .imageOcr(
              imagePath: imagePath,
              ocrType: ImageConstants.getImageOcrType(widget.imageType),
              idSide: ImageConstants.getImageSide(widget.imageType))
          .then((res) {
        print(res);
      });
    }
  }
}
