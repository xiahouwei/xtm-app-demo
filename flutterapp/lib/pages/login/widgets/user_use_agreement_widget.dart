import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/common/h5_page/h5_page_manage.dart';

class UserUseAgreementWidget extends StatefulWidget {
  final Function(bool isChecked) checkCallback;
  final bool isSelected;

  UserUseAgreementWidget({this.isSelected = false, @required this.checkCallback});

  @override
  State<UserUseAgreementWidget> createState() => _UserUseAgreementWidgetState();
}

class _UserUseAgreementWidgetState extends State<UserUseAgreementWidget> {
  TapGestureRecognizer _userAgreementRecognizer = TapGestureRecognizer()
    ..onTap = () {
      H5PageManager.navigator2UserAgreementPage();
    };
  TapGestureRecognizer _privacyAgreementRecognizer = TapGestureRecognizer()
    ..onTap = () {
      H5PageManager.navigator2PrivacyAgreementPage();
    };
  TapGestureRecognizer _platformTransactionRulesRecognizer = TapGestureRecognizer()
    ..onTap = () {
      H5PageManager.navigator2PlatformTransactionRulesPage();
    };

  bool _isCheckAgreement = false;

  @override
  void initState() {
    super.initState();
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
        padding: EdgeInsets.only(top: 12, bottom: 10, left: 10, right: 10),
        child: _isCheckAgreement
            ? Icon(Icons.check_circle, color: Color(0xFF21CAFC), size: 16)
            : Icon(Icons.radio_button_unchecked, color: Colors.white, size: 16),
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
      text: TextSpan(
        style: TextStyle(height: 1.5, fontSize: 13),
        children: [
          TextSpan(text: '我已阅读并同意', style: TextStyle(color: Colors.white, fontSize: 13)),
          TextSpan(
            text: '《用户使用协议》',
            style: TextStyle(color: Color(0xFF21CAFC), fontSize: 13),
            recognizer: _userAgreementRecognizer,
          ),
          TextSpan(
            text: '《隐私政策》',
            style: TextStyle(color: Color(0xFF21CAFC), fontSize: 13),
            recognizer: _privacyAgreementRecognizer,
          ),
          TextSpan(
            text: '《平台交易规则协议》',
            style: TextStyle(color: Color(0xFF21CAFC), fontSize: 13),
            recognizer: _platformTransactionRulesRecognizer,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userAgreementRecognizer.dispose();
    _privacyAgreementRecognizer.dispose();
    _platformTransactionRulesRecognizer.dispose();
    super.dispose();
  }
}
