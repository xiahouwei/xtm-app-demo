import 'package:flutter_proj/constants/image_constants.dart';

class UploadImageModel {
  ImageTypeEnum imageType;
  ImageTypeEnum displayImageType;
  String imageDesc;
  String imageAlias;
  bool isRequired;
  String imgId;
  bool isOcr;

  UploadImageModel({
    this.imageType,
    this.displayImageType,
    this.imageDesc,
    this.imageAlias,
    this.isRequired,
    this.imgId,
    this.isOcr,
  });
}
