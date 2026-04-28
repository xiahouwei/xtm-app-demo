import 'package:flutter_proj/constants/common_constant.dart';
import 'package:flutter_proj/network/http_api.dart';
import 'package:flutter_proj/utils/time_utils.dart';

class ApiMessage {
  /// 消息类型列表
  Future<T> getMessageTypeList<T>({bool showLoading = true}) async => xtmHttpApi.post(
        HttpOptions(
          path: 'msg/setting/message/index',
          queryParameters: {
            'appChannel': AppChannel.appChannelName,
          },
          showLoading: showLoading,
        ),
      );

  /// 某类消息类型列表
  Future<T> getMessageList<T>(int pageNum, int type, String startTime, String endTime) async => xtmHttpApi.post(
    HttpOptions(
      path: 'msg/setting/message/detail',
      params: {
        'appChannel': AppChannel.appChannelName,
        'pageNum': pageNum,
        'pageSize': CommonConstant.PAGE_SIZE,
        'type': type,
        'startTime': TimeUtils.getBeginOfDay(date: startTime),
        'endTime': TimeUtils.getEndOfDay(date: endTime),
      },
    ),
  );

  /// 最新消息列表
  Future<T> getUnReadMessageList<T>(int pageNum) async => xtmHttpApi.post(
        HttpOptions(
          path: 'msg/setting/message/unRead/list',
          params: {
            'appChannel': AppChannel.appChannelName,
            'pageNum': pageNum,
            'pageSize': CommonConstant.PAGE_SIZE
          },
        ),
      );

  /// 一键已读
  Future<T> clearUnReadMessage<T>() async => xtmHttpApi.post(
    HttpOptions(
      path: 'msg/setting/message/readAll',
      queryParameters: {
        'appChannel': AppChannel.appChannelName,
      },
    ),
  );

  /// 消息详情
  Future<T> getMessageDetail<T>(String id) async => xtmHttpApi.get(
    HttpOptions(
      path: 'msg/setting/message/detailInfo/$id',
    ),
  );

  /// 消息详情标记已读
  Future<T> clearMessageDetailUnRead<T>(String id) async => xtmHttpApi.put(
    HttpOptions(
      path: 'msg/message/read/$id',
    ),
  );




}
