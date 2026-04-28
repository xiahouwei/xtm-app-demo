// import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/models/message/message_list_model.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/utils/async_utils.dart';
// import 'package:flutter_proj/utils/navigator_provider_utils.dart';
// import 'package:flutter_proj/pages/message/detail/message_detail_page.dart';

typedef PushHandler = void Function(Map<String, dynamic> params);

class NotificationRedirect {
  static final Map<String, PushHandler> _handlers = {
    ..._noticeToMessageDetailHandlers([]),
  };

  static pushPage(Map<String, dynamic> params) async {
    if (!xtmGlobalStore.auth.isLogin) return;
    String type = params['type'];
    if (type == null) {
      return;
    }
    final handler = _handlers[type];
    if (handler != null) {
      handler(params);
    }
  }

  static Map<String, PushHandler> _noticeToMessageDetailHandlers(List<String> types) {
    return {
      for (final type in types)
        type: (params) {
          String detailId = params['msgDetailId'];
          getMessageDetailById(detailId).then((value) {
            _pushMessageDetailPage(detailId);
          });
        }
    };
  }

  static Future<MessageModel> getMessageDetailById(String id) {
    return AsyncUtils.PromiseFunction<MessageModel>((promise) async {
      xtmApi.message.getMessageDetail(id).then((value) {
        MessageModel model = MessageModel.fromJson(value);
        promise.complete(model);
      });
    });
  }

  static _pushMessageDetailPage(String detailId) {
    // NavigatorProvider.navigatorKey.currentState?.push(MaterialPageRoute(
    //   builder: (ctx) {
    //     return MessageDetailPage(detailId: detailId);
    //   },
    // ));
  }
}
