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
  final String imgUrl;
  final BoxFit fit;
  final double width;
  final double height;
  final bool isRequired;
  final bool onlyCamera;
  final String imgDesc;

  /// 上传图片业务类型
  final String businessSource;
  final ImageTypeEnum imageType;
  final ValueChanged<String> onImageUploaded;
  final String errorImgPath;
  final bool disabled;
  final bool isOcr;
  final ValueChanged<Map<String, dynamic>> onOcrSuccess;

  ImageUpload({
    Key key,
    this.imgId,
    this.imgUrl,
    this.fit = BoxFit.contain,
    this.width = 108,
    this.height = 68,
    this.isRequired = false,
    this.imgDesc,
    this.imageType,
    this.businessSource = UploadBusSourceConstant.APP_SHIPPER_BUSINESS,
    this.onImageUploaded,
    this.errorImgPath,
    this.isOcr = false,
    this.onOcrSuccess,
    this.onlyCamera = false,
    this.disabled = false,
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
          imgUrl: widget.imgUrl ?? _getImageUrlById(widget.imgId),
          token: xtmGlobalStore.auth.token ?? '',
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          isRequired: widget.isRequired,
          onlyCamera: widget.onlyCamera,
          imgDesc: widget.imgDesc,
          placeholderPath: ImageConstants.getPlaceholderImagePath(widget.imageType),
          errorImgPath: widget.errorImgPath,
          onImageSelected: (imagePath) {
            _uploadImage(imagePath);
          },
          disabled: widget.disabled,
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
      imageSrc = HTTPConfig.serverDomain + '/apiPlat/tms-file/downLoad/$id';
    }
    return imageSrc;
  }

  /// 上传图片
  void _uploadImage(String imagePath) async {
    Map<String, dynamic> res;
    try {
      res = await xtmApi.image.uploadFile(imagePath, widget.businessSource);
      setState(() => showError = false);
    } catch (e) {
      setState(() => showError = true);
    }
    widget.onImageUploaded(res['fileId']);
    // 如果开启OCR  进行OCR识别
    if (widget.isOcr) {
      String _ocrType = ImageConstants.getImageOcrType(widget.imageType);
      if (_ocrType.isEmpty) {
        XtmToast.warn('该图片不支持OCR识别！');
        return;
      }
      await xtmApi.image
          .imageOcr(imagePath: imagePath, ocrType: _ocrType, idSide: ImageConstants.getImageSide(widget.imageType))
          .then((res) {
        widget.onOcrSuccess(res);
      });
    }
  }
}
