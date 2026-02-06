import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_proj/network/http_api.dart';
import 'package:flutter_proj/network/http_manager.dart';

class ImageApi {
  /// 上传文件
  Future<T> uploadFile<T>(String imagePath, String businessSource) {
    Map<String, dynamic> params = {};
    params['file'] = MultipartFile.fromFileSync(imagePath);
    params['businessSource'] = businessSource;
    params['agentCode'] = 'app';
    return xtmHttpApi.post(
      HttpOptions(
        path: 'file/files/upload',
        contentType: RequestContentType.FORM_DATA,
        params: params,
      ),
    );
  }

  /// 图片识别
  Future<T> imageOcr<T>({
    @required String imagePath,
    @required String ocrType,
    @required String idSide,
  }) {
    Map<String, dynamic> params = {
      'imageFile': MultipartFile.fromFileSync(imagePath),
      'ocrType': ocrType,
      'idSide': idSide,
    };
    return xtmHttpApi.post(
      HttpOptions(
        path: 'file/ocr/imageOcr',
        contentType: RequestContentType.FORM_DATA,
        params: params,
      ),
    );
  }
}
