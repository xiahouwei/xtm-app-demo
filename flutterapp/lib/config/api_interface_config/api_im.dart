import 'package:dio/dio.dart';
import 'package:flutter_proj/network/http_manager.dart';
import 'package:flutter_proj/network/http_api.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';

/// 在线客服类 接口
class ImApi {
  /// 上传文件
  Future<T> uploadFile<T>(String filePath) {
    Map<String, dynamic> params = {
      'file': MultipartFile.fromFileSync(filePath),
    };
    return xtmHttpApi.post(
      HttpOptions(
        requestBaseUrl: HTTPConfig.chatServiceDomain,
        path: '/file/upload',
        contentType: RequestContentType.FORM_DATA,
        params: params,
      ),
    );
  }

  /// 查询客服未读消息
  Future<T> getChatMessageUnReadByLastDatetime<T>(String recentTime) {
    Map<String, dynamic> params = {
      'driverNo': xtmGlobalStore.auth.userInfo.userID,
      'recentTime': recentTime
    };
    return xtmHttpApi.post(
      HttpOptions(
        requestBaseUrl: HTTPConfig.chatServiceDomain,
        path: '/session/recentMessageCount',
        params: params,
      ),
    );
  }
}
