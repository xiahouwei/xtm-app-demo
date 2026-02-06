import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/common/h5_page/h5_page_manage.dart';

class UserUseAgreementWidget extends StatefulWidget {
  final Function(bool isChecked) checkCallback;
  final bool isSelected;

  UserUseAgreementWidget({this.isSelected = false, @required this.checkCallback});

  @override
  State<UserUseAgreementWidget> createState() => _UserUseAgreementWidgetState();
}

class _UserUseAgreementWidgetState extends State<UserUseAgreementWidget> {
  TapGestureRecognizer _privateProtocolRecognizer;

  bool _isCheckAgreement = false;

  @override
  void initState() {
    super.initState();
    _privateProtocolRecognizer = TapGestureRecognizer()
      ..onTap = () {
        H5PageManange.navigator2PrivacyAgreementPage();
      };
    _isCheckAgreement = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant UserUseAgreementWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isCheckAgreement = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dotBtn(),
            Expanded(child: displayProtocol()),
          ],
        ));
  }

  Widget dotBtn() {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(12, 4, 6, 12),
        child: Image.asset(
          'assets/images/login/${_isCheckAgreement ? 'login_check_sel.png' : 'login_check_nor.png'}',
          width: 13,
          height: 13,
        ),
      ),
      onTap: () {
        setState(() {
          _isCheckAgreement = !_isCheckAgreement;
        });
        if (widget.checkCallback != null) {
          widget.checkCallback(_isCheckAgreement);
        }
      },
    );
  }

  Widget displayProtocol() {
    return RichText(
      text: TextSpan(style: TextStyle(height: 1.5, fontSize: 12), children: [
        factoryTextSpan(textStr: '我已阅读并同意'),
        TextSpan(
          text: '《隐私政策》',
          style: TextStyle(color: XtmColor.themeColor, fontSize: 12),
          recognizer: _privateProtocolRecognizer,
        ),
      ]),
    );
  }

  TextSpan factoryTextSpan({@required String textStr}) {
    return TextSpan(
        text: textStr,
        style: TextStyle(
            color: _isCheckAgreement ? Colors.black : Color.fromRGBO(124, 139, 160, 1.0),
            fontSize: 12));
  }

  @override
  void dispose() {
    _privateProtocolRecognizer.dispose();
    super.dispose();
  }
}
