import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:flutter_proj/common/event_bus/event_bus.dart';
import 'package:flutter_proj/common/event_bus/event_bus_type.dart';
import 'package:flutter_proj/store/global_store.dart';

class ProgressIndicatorManage {
  static Future showProgressIndicator(BuildContext context,
      {String downloadUrl, String boxUrl}) async {
    List modelArr = await showDialog(
        context: context,
        barrierColor: Color.fromRGBO(14, 14, 14, 0.5),
        barrierDismissible: false,
        builder: (ctx) {
          return UpdateWidget(
            downloadUrl: downloadUrl,
            boxUrl: boxUrl,
          );
        });
    return modelArr;
  }
}

class UpdateWidget extends StatefulWidget {
  final String downloadUrl;
  final String boxUrl;
  UpdateWidget({@required this.downloadUrl, @required this.boxUrl});

  @override
  _UpdateWidgetState createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
  int _totalReceive = 0;
  StreamSubscription _progressSub;

  @override
  void initState() {
    super.initState();
    _progressSub = eventBus.on(EventBusType.PROGRESS_UPDATE, (data) {
      calculateNum('${xtmGlobalStore.system.receiveCount}');
    });
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    super.dispose();
  }

  void calculateNum(String receiveCount) {
    if (receiveCount != null && receiveCount.isNotEmpty) {
      int rec = int.parse(receiveCount);
      if (rec == _totalReceive) {
        ///与上次相同，就不处理了
      } else {
        ///有增加
        _totalReceive = rec;
        print('---下载进度-----$rec----');
        setState(() {});
      }
    }
  }

  void openBrowser(String url) async {
    if (url == null || url.isEmpty) {
      XtmToast.warn('无法获取下载链接，请重试');
      return;
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      XtmToast.warn('无法打开浏览器,请检查是否安装浏览器');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 80,
            decoration: BoxDecoration(
                color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            child: Image.asset(
                                'assets/images/version_update/version_update_dialog_bg.png'),
                            width: double.infinity,
                          ),
                          Positioned(
                            top: 40,
                            left: 30,
                            child: textWidget(
                                title: '软件更新',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: XtmColor.themeColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      progressWidget(),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: textWidget(
                            title: '若当前下载较慢，可使用网盘下载',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: XtmColor.themeColor),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          downButtonWidget(
                              title: '官网下载',
                              onTap: () {
                                Navigator.of(context).pop();
                                openBrowser(widget.downloadUrl);
                              }),
                          Offstage(
                              offstage: (widget.boxUrl == null || widget.boxUrl.isEmpty),
                              child: SizedBox(
                                width: 20,
                              )),
                          Offstage(
                            offstage: (widget.boxUrl == null || widget.boxUrl.isEmpty),
                            child: downButtonWidget(
                                title: '网盘下载',
                                onTap: () {
                                  Navigator.of(context).pop();
                                  openBrowser(widget.boxUrl);
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 22,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: -8,
                    right: 30,
                    child: Image.asset(
                      'assets/images/version_update/version_update_dialog_rocket.png',
                      width: 180,
                      height: 120,
                    ))
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  Widget progressWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                      value: double.parse(_totalReceive.toString()) / 100,
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(33, 119, 251, 1.0)),
                      backgroundColor: Color.fromRGBO(241, 242, 242, 1.0),
                      minHeight: 20),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 130,
          height: 30,
          child: Center(
              child: Text(
            '$_totalReceive%',
            style: TextStyle(
                color: XtmColor.themeColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none),
          )),
        )
      ],
    );
  }

  Widget textWidget({String title, double fontSize, FontWeight fontWeight, Color color}) {
    return Text(title ?? '',
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            decoration: TextDecoration.none));
  }

  Widget downButtonWidget({String title, GestureTapCallback onTap}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45 / 2.0),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(35, 115, 251, 1.0),
              Color.fromRGBO(15, 168, 254, 1.0),
            ])),
        child: textWidget(title: title, fontSize: 13, color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}

class ProgressDemo extends StatefulWidget {
  ProgressDemo({Key key}) : super(key: key);

  @override
  _ProgressDemoState createState() => _ProgressDemoState();
}

class _ProgressDemoState extends State<ProgressDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter progress demo'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: TextButton(
          child: Text('进度'),
          // color: Colors.blue,
          onPressed: () {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  title: Text('上传中...'),
                  content: LinearProgressIndicator(
                    value: 0.3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    backgroundColor: Colors.blue,
                  ),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
