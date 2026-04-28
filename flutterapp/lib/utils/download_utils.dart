import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DownloadUtils {
  static void downloadFileWithBrowser(String url) async {
    if (url == null || url.isEmpty) {
      XtmToast.info('无法获取下载链接，请重试');
      return;
    }
    String token = xtmGlobalStore.auth.token;
    String fileUrl = url + '?token=$token';
    if (await canLaunchUrlString(fileUrl)) {
      await launchUrlString(fileUrl, mode: LaunchMode.externalApplication);
    } else {
      XtmToast.info('无法打开浏览器,请检查是否安装浏览器');
    }
  }
}
