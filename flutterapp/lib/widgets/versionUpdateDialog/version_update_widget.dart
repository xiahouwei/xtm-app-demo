import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';

class VersionUpdateWidget extends StatelessWidget {
  final String latestVersionDesc;
  final String currentVersionDesc;
  final bool hiddenBoxButton;
  final WillPopCallback onWillPop;
  final GestureTapCallback onLeftTap;
  final GestureTapCallback onRightTap;
  VersionUpdateWidget({
    this.latestVersionDesc,
    this.currentVersionDesc,
    this.hiddenBoxButton,
    this.onLeftTap,
    this.onRightTap,
    this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                          color: XtmColor.themeColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: textWidget(
                      title: latestVersionDesc,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: XtmColor.themeColor,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: textWidget(
                        title: currentVersionDesc,
                        fontSize: 14,
                        color: Color.fromRGBO(111, 126, 142, 1.0)),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      updateButtonWidget(
                          title: '立即更新',
                          onTap: () {
                            Navigator.of(context).pop();
                            if (onLeftTap != null) {
                              onLeftTap();
                            }
                          }),
                      Offstage(
                          offstage: hiddenBoxButton != null && hiddenBoxButton,
                          child: SizedBox(
                            width: 20,
                          )),
                      Offstage(
                        offstage: hiddenBoxButton != null && hiddenBoxButton,
                        child: updateButtonWidget(
                            title: '网盘下载',
                            onTap: () {
                              Navigator.of(context).pop();
                              if (onRightTap != null) {
                                onRightTap();
                              }
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
      )),
      onWillPop: onWillPop,
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

  Widget updateButtonWidget({String title, GestureTapCallback onTap}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45 / 2.0),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(15, 168, 254, 1.0),
              Color.fromRGBO(35, 115, 251, 1.0),
            ])),
        child: textWidget(title: title, fontSize: 13, color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
