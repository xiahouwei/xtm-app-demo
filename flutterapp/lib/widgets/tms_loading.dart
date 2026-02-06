import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

export 'package:bot_toast/bot_toast.dart';

class TmsLoading {
  /// dismissOnClick 可否点击停止loading
  /// dismissByBackButton：是否能通过物理返回键停止loading
  static CancelFunc showLoading({bool dismissOnClick = false, bool dismissByBackButton = false}) {
    return BotToast.showCustomLoading(
      toastBuilder: (_) => CircularLoadingWidget(),
      backgroundColor: Colors.transparent,
      crossPage: false,
      clickClose: dismissOnClick,
      backButtonBehavior: dismissByBackButton == false ? BackButtonBehavior.ignore : BackButtonBehavior.close,
    );
  }

  /// text 文字
  /// dismissOnClick 可否点击停止loading
  /// dismissByBackButton：是否能通过物理返回键停止loading
  static CancelFunc showTextLoading(String text, {bool dismissOnClick = false, bool dismissByBackButton = false}) {
    return BotToast.showCustomLoading(
      toastBuilder: (_) => CircularLoadingWithTextWidget(
        text: text,
      ),
      backgroundColor: Colors.transparent,
      crossPage: false,
      clickClose: dismissOnClick,
      backButtonBehavior: dismissByBackButton == false ? BackButtonBehavior.ignore : BackButtonBehavior.close,
    );
  }

  static dismiss() {
    BotToast.closeAllLoading();
  }
}

//加载提示的Widget
class CircularLoadingWidget extends StatelessWidget {
  const CircularLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(30, 30, 30, 0.9),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: const CircularProgressIndicator(),
    );
  }
}

//加载带文字提示的Widget
class CircularLoadingWithTextWidget extends StatelessWidget {
  final String text;

  const CircularLoadingWithTextWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 80 * 2),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(30, 30, 30, 0.9),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      // child: const CircularProgressIndicator(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
          )
        ],
      ),
    );
  }
}
