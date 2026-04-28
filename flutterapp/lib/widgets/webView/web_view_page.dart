import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/app_bar/xtm_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './web_view_js_channel_manager.dart';

class WebViewJsCallBackConstants {
  /// web页面提供后退功能,根据返回退出webview
  static const String GO_BACK = 'webviewCallback.goBack()';
}

///webView类
class WebViewPage extends StatefulWidget {
  /// 页面标题（为空则不显示 AppBar）
  final String titleStr;

  /// WebView 初始加载的 URL
  final String urlString;

  /// 是否在键盘弹出时自动调整页面高度
  final bool resizeToAvoidBottomInset;

  /// 是否清除缓存
  final bool clearCache;

  /// 是否需要webview自己控制后退
  final bool webviewPopBySelf;

  /// 是否显示网页加载进度条
  final bool showProgress;

  /// 给调用页回调数据
  final Function(Map<String, dynamic> data) onCallBack;

  WebViewPage({
    @required this.urlString,
    this.titleStr,
    this.resizeToAvoidBottomInset = false,
    this.clearCache = true,
    this.webviewPopBySelf = false,
    this.showProgress = false,
    this.onCallBack,
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  TextEditingController controller = TextEditingController();

  WebViewController _controller;
  double progressValue = 0.0;
  bool isShowProgress = false;

  WebViewJsChannelManager webViewJsChannelManager = WebViewJsChannelManager();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.webviewPopBySelf) {
      return buildScaffold(context);
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: buildScaffold(context),
      );
    }
  }

  Future<bool> _onWillPop() async {
    return _controller.evaluateJavascript(WebViewJsCallBackConstants.GO_BACK).then((value) {
      if (value == 'false') {
        return false;
      }
      return true;
    });
  }

  Widget buildScaffold(BuildContext context) {
    PreferredSizeWidget tabBar;
    if (widget.titleStr != null) {
      tabBar = XtmAppBar(title: widget.titleStr);
    }
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      appBar: tabBar,
      body: SafeArea(
          child: Stack(
        children: [
          buildWebView(),
          buildProgressLine(),
        ],
      )),
    );
  }

  Widget buildProgressLine() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Offstage(
        offstage: !isShowProgress,
        child: SizedBox(
          height: 2,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: progressValue,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              final safeValue = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;
              return LinearProgressIndicator(
                value: safeValue,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(XtmColor.themeColor),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildWebView() {
    return WebView(
      initialUrl: widget.urlString,
      debuggingEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: webViewJsChannelManager.buildJavascriptChannels(),
      onWebViewCreated: (con) {
        _controller = con;
        if (widget.clearCache) {
          _controller.clearCache();
        }
        webViewJsChannelManager.setControl(_controller);
        webViewJsChannelManager.setCallBack(context, widget.onCallBack);
      },
      navigationDelegate: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        if (!widget.showProgress) {
          return;
        }
        isShowProgress = true;
      },
      onProgress: (int progress) {
        if (!widget.showProgress) {
          return;
        }
        setState(() {
          progressValue = progress / 100.0;
        });
      },
      onPageFinished: (url) {
        if (!widget.showProgress) {
          return;
        }
        setState(() {
          progressValue = 1.0;
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              isShowProgress = false;
              progressValue = 0.0;
            });
          }
        });
      },
    );
  }
}
