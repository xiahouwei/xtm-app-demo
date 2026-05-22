import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_proj/network/http_config.dart';

class DownloadUtils {
  /// 创建文件下载路径
  static String createDownloadUrlByFileId(String fileId) {
    if (fileId == null || fileId.isEmpty) {
      return '';
    }
    return HTTPConfig.serverDomain + '/apiPlat/tms-file/downLoad/${fileId}';
  }

  /// 通过默认浏览器和url下载文件
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

  /// 通过默认浏览器和文件id下载文件
  static void downloadFileByFileIdWithBrowser(String fileId) async {
    String url = createDownloadUrlByFileId(fileId);
    await downloadFileWithBrowser(url);
  }
}
