import 'package:flutter/material.dart';
import 'package:flutter_proj/device/device_phone.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';

class MobileNumberDialog {
  static showMobileNumDialog(BuildContext context, List<String> items) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Builder(builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/widgets/image_service_phone_bg.png'),
                            fit: BoxFit.cover)),
                    child: Container(
                      margin: const EdgeInsets.only(top: 80),
                      padding: const EdgeInsets.only(top: 20),
                      height: 135,
                      width: 250,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          String itemStr = items[index];
                          if (itemStr == '') {
                            return Container();
                          }
                          return Container(
                            margin: const EdgeInsets.only(
                                bottom: 25, left: 40, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  itemStr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                )),
                                GestureDetector(
                                  child: Image.asset(
                                    'assets/images/widgets/image_service_call.png',
                                    width: 75,
                                    height: 25,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _makeCall(itemStr);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }

  static _makeCall(String number) async {
    xtmPhone.callDialog(NavigatorProvider.navigatorContext, number);
  }
}
