import 'package:flutter_proj/network/http_api.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/network/http_manager.dart';
import 'package:flutter_proj/network/tms_http_request.dart';
import 'package:flutter_proj/store/global_store.dart';

class MineApi {
  /// 保存用户头像
  Future<T> saveUserHeaderImage<T>(
    String mobile,
    String portraitPhotoFileID,
    List organTypeIds,
  ) async =>
      xtmHttpApi.post(
        HttpOptions(
          path: 'userInfoUpd',
          contentType: RequestContentType.APPLICATION_FORM,
          params: {
            'mobile': mobile,
            'portraitPhotoFileID': portraitPhotoFileID,
            'organTypeIds': organTypeIds,
            'app_key': HTTPConfig.appKey
          },
        ),
      );

  /// 发送验证码
  Future<T> getSmsCode<T>(String mobile, String bizCode) async => xtmHttpApi.post(HttpOptions(
          path: 'getCaptcha',
          contentType: RequestContentType.APPLICATION_FORM,
          params: {
            'mobile': mobile,
            'bizCode': bizCode,
          }));

  /// 修改密码
  Future<T> updatePwd<T>(String mobile, String smsCode, String newPwd) async =>
      xtmHttpApi.post(HttpOptions(
          path: 'passwordUpd',
          contentType: RequestContentType.APPLICATION_FORM,
          params: {'mobile': mobile, 'captcha': smsCode, 'newPassword': newPwd}));

  /// 验证旧手机号
  Future<T> verifyOldPhone<T>(String mobile, String smsCode, String userId) async =>
      xtmHttpApi.post(
        HttpOptions(
          requestBaseUrl: TmsHttpRequest.TMS_SERVER_PATH,
          path: 'verifyMobile',
          params: {
            'mobile': mobile,
            'messageCode': smsCode,
            'userId': userId,
          },
        ),
      );

  /// 更换手机号
  Future<T> updatePhone<T>(String mobile, String smsCode, String userId) async => xtmHttpApi.post(
        HttpOptions(
          requestBaseUrl: TmsHttpRequest.TMS_SERVER_PATH,
          path: 'changeMobile',
          params: {
            'mobile': mobile,
            'messageCode': smsCode,
            'userId': userId,
          },
        ),
      );

  /// 通过身份证、密码验证账号有效性
  Future<T> verifyAccount<T>(String idcardNo, String pws, String userId) async => xtmHttpApi.post(
        HttpOptions(
          requestBaseUrl: TmsHttpRequest.TMS_SERVER_PATH,
          path: 'verifyAccount',
          params: {
            'idcardNo': idcardNo,
            'password': pws,
            'userId': userId,
          },
        ),
      );

  /// 注销账号
  Future<T> cancelAccount<T>(String userId) async => xtmHttpApi.post(
        HttpOptions(
          path: 'cancel',
          contentType: RequestContentType.APPLICATION_FORM,
          params: {
            'userId': userId,
          },
        ),
      );

  /// 获取下载app二维码
  Future<T> getDownloadAppQRCode<T>(String companyAgentId) async => xtmHttpApi.post(
        HttpOptions(
          path: 'companyIndexQry',
          contentType: RequestContentType.APPLICATION_FORM,
          params: {
            'agentID': companyAgentId,
          },
        ),
      );

  /// 查询客服电话
  Future<T> getServicePhone<T>() async => xtmHttpApi.post(
        HttpOptions(
          path: 'platform/getIndexSetting',
          contentType: RequestContentType.APPLICATION_FORM,
        ),
      );

  /// 经营数据
  Future<T> getBusinessData<T>() async {
    String companyId = xtmGlobalStore.auth.userInfo.companyInfo.companyID;
    Map<String, dynamic> param = {
      'statisticsStyle': 0,
      'companyId': companyId,
    };
    return xtmHttpApi.post(
      HttpOptions(
          path: 'tms-finance/receivePayDetail/dispatchBatch/verification/statistics',
          params: param),
    );
  }
}
