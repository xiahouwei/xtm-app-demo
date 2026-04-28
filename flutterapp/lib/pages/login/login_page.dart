import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_proj/common/h5_page/h5_url_manage.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/constants/login_constants.dart';
import 'package:flutter_proj/device/index.dart';
import 'package:flutter_proj/models/login/user_info_model.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/utils/async_utils.dart';
import 'package:flutter_proj/utils/countdown_util.dart';
import 'package:flutter_proj/utils/string_utils.dart';
import 'package:flutter_proj/widgets/webView/web_view_page.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:photo_view/photo_view.dart';

import 'setting_password_page.dart';
import 'widgets/show_user_agreement_dialog.dart';
import 'widgets/user_notice_dialog.dart';
import 'widgets/user_use_agreement_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String _loginType = LoginConstants.LOGIN_TYPE_MOBILE;
  String versionCode = '';
  bool _agreementSelected = false;
  bool isShowSecretDialog = true;

  GlobalKey<FormState> _formKey;
  GlobalKey<FormFieldState> _mobileKey;
  TextEditingController _mobileController;
  TextEditingController _pwdController;
  TextEditingController _smsCodeController;

  CountdownTimerUtil _countdownTimer;

  /// 背景动画控制器
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _mobileKey = GlobalKey<FormFieldState>();
    _mobileController = TextEditingController();
    _pwdController = TextEditingController();
    _smsCodeController = TextEditingController();
    _countdownTimer = CountdownTimerUtil();

    // 初始化动画
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_animationController);

    initInputDefaultValue();
    initVersionCode();
    checkVersion();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      agreementHandler();
    });
  }

  void checkVersion() {
    xtmApi.auth.checkVersion();
  }

  void initInputDefaultValue() {
    String userName = xtmGlobalStore.auth.userName;
    String password = xtmGlobalStore.auth.password;
    _mobileController.text = userName;
    if (_loginType == LoginConstants.LOGIN_TYPE_MOBILE) {
      _pwdController.text = password;
    }
    setState(() {});
  }

  void initVersionCode() async {
    String _versionCode = await xtmDevice.deviceInfo.getAppVersion();
    setState(() {
      versionCode = _versionCode;
    });
  }

  Future<void> agreementHandler() {
    return AsyncUtils.PromiseFunction<String>((promise) async {
      if (xtmGlobalStore.auth.showSecretDialog) {
        UserNoticeDialog.showProtocolView().then((val) {
          promise.complete();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildLoginBg(),
          GestureDetector(
            child: buildContentWidget(),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBg() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double dx = -_animation.value * 300;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: PhotoView(
            enableRotation: false,
            disableGestures: true,
            imageProvider: AssetImage('assets/images/login/login_bg.png'),
            initialScale: 0.48,
          ),
        );
      },
    );
  }

  Widget buildContentWidget() {
    return Column(
      children: [
        Expanded(child: displayBodyContent()),
        Image.asset(
          'assets/images/login/login_bottom_name.png',
          width: 300,
          fit: BoxFit.fitWidth,
        ),
        buildVersionText(),
        SizedBox(height: 10),
      ],
    );
  }

  Widget displayBodyContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 100),
            Image.asset('assets/images/login/login_logo.png', width: 60, fit: BoxFit.fitWidth),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/images/login/login_company.png',
                  height: 60, fit: BoxFit.fitHeight),
            ),
            SizedBox(height: 20),
            _buildLoginType(),
            SizedBox(height: 10),
            _displayMobile(),
            SizedBox(height: 10),
            _loginType == LoginConstants.LOGIN_TYPE_MOBILE ? _displayPwd() : buildSMSCodeInput(),
            SizedBox(height: 10),
            UserUseAgreementWidget(
              isSelected: _agreementSelected,
              checkCallback: (bool isCheck) {
                _agreementSelected = isCheck;
              },
            ),
            SizedBox(height: 30),
            XtmTextButton(
              text: '登录',
              width: double.infinity,
              fontSize: 16,
              onPressed: () => tapLoginBtn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginType() {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _loginType = LoginConstants.LOGIN_TYPE_MOBILE;
              _formKey.currentState.reset();
              FocusScope.of(context).unfocus();
            });
          },
          child: Text(
            '密码登录',
            style: TextStyle(
              color: _loginType == LoginConstants.LOGIN_TYPE_MOBILE ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 20),
        TextButton(
          onPressed: () {
            setState(() {
              _loginType = LoginConstants.LOGIN_TYPE_SMS;
              _formKey.currentState.reset();
              FocusScope.of(context).unfocus();
            });
          },
          child: Text(
            '验证码登录',
            style: TextStyle(
              color: _loginType == LoginConstants.LOGIN_TYPE_SMS ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _displayMobile() {
    return XtmInput(
      formFieldKey: _mobileKey,
      label: '手机号码',
      borderColor: Colors.white,
      inputType: TextInputType.number,
      clear: true,
      controller: _mobileController,
      maxSize: 11,
      inputFormatters: [XtmInputFormatter.numbersOnly],
      validator: (value) {
        if (value.trim().isEmpty) {
          return '请输入手机号码';
        }
        if (!StringUtils.isPhoneNum(value.trim())) {
          return '请输入正确的手机号码';
        }
        return null;
      },
    );
  }

  Widget _displayPwd() {
    return XtmInput(
      label: '密码',
      inputType: TextInputType.visiblePassword,
      controller: _pwdController,
      clear: true,
    );
  }

  Widget buildSMSCodeInput() {
    return XtmInput(
      label: '验证码',
      controller: _smsCodeController,
      inputType: TextInputType.number,
      clear: true,
      inputFormatters: [XtmInputFormatter.numbersOnly],
      suffix: ValueListenableBuilder(
        valueListenable: _countdownTimer.remainingSeconds,
        builder: (BuildContext context, int value, Widget child) {
          return GestureDetector(
            onTap: () {
              if (_countdownTimer.canSend) {
                requestSMSCode();
              }
            },
            child: Text(
              _countdownTimer.displayText,
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          );
        },
      ),
    );
  }

  void tapLoginBtn() {
    int receiveCount = xtmGlobalStore.system.receiveCount;
    if (receiveCount != null && receiveCount > 0 && receiveCount < 100) {
      XtmToast.info('正在下载中，请稍后再试，已下载$receiveCount%');
    } else {
      FocusManager.instance.primaryFocus.unfocus();
      loginAction();
    }
  }

  Widget buildVersionText() {
    return Text(versionCode, style: TextStyle(fontSize: 12, color: Colors.white));
  }

  void showUserAgreementDialog() {
    ShowUserAgreementDialog.showAgreementDialog(context, () {
      setState(() {
        _agreementSelected = true;
      });
    });
  }

  void requestSMSCode() {
    if (!_mobileKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _isShowPicCode();
  }

  void _isShowPicCode() {
    xtmApi.auth.showPicCapture(mobile: _mobileController.text.trim()).then((value) {
      if (value['body']['content']['registered']) {
        _sendSmsCode('');
      } else {
        showCaptchaDialog();
      }
    });
  }

  void showCaptchaDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.width - 40,
            child: WebViewPage(
              urlString: H5UrlManager.getCaptchaUrl(),
              clearCache: false,
              onCallBack: (data) {
                if (data != null) {
                  _sendSmsCode(data['code']);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _sendSmsCode(String picCode) {
    Map<String, dynamic> params = {
      'mobile': _mobileController.text.trim(),
      'bizCode': '4',
      'graphicCode': picCode,
    };
    xtmApi.auth.getSmsCode(params: params).then((value) => _countdownTimer.start());
  }

  void loginAction() async {
    if (!_agreementSelected) {
      showUserAgreementDialog();
      return;
    }
    if (!_formKey.currentState.validate()) {
      return;
    }
    xtmGlobalStore.auth.setToken(HTTPConfig.baseToken);
    HTTPConfig.updateDomainByIos(_mobileController.text.trim());
    Map<String, dynamic> loginParam = {};
    loginParam['mobile'] = _mobileController.text.trim();
    loginParam['password'] = _pwdController.text.trim();
    loginParam['messageCode'] = _smsCodeController.text.trim();
    loginParam['loginTypeCode'] = _loginType;
    loginParam['hardwareInformation'] = '';
    xtmApi.auth.loginByMobile(params: loginParam).then((res) => handleToken(res));
  }

  void handleToken(Map<String, dynamic> res) async {
    var token = res['header']['token'];
    if (token != null) {
      xtmGlobalStore.auth.setToken(token);
    }
    xtmGlobalStore.auth.setIsLogin(true);
    handleUserInfo(res['body']['content']['userInfo']);
    // bindGpushClientId();
    loginStatusSetting();
  }

  void handleUserInfo(Map<String, dynamic> res) {
    xtmGlobalStore.auth.setUserName(_mobileController.text.trim());
    if (_loginType == LoginConstants.LOGIN_TYPE_MOBILE) {
      xtmGlobalStore.auth.setPassword(_pwdController.text.trim());
    }
    UserInfoModel userInfo = UserInfoModel.fromJson(res);
    if (userInfo != null) {
      xtmGlobalStore.auth.setUserInfo(userInfo);
    }
  }

  // void bindGpushClientId() {
  //   xtmApi.auth.bindClientId();
  // }

  void loginStatusSetting() {
    if (_loginType == LoginConstants.LOGIN_TYPE_SMS) {
      checkExistsPwdRequest();
    } else {
      changeRootPageAndLoginStatus();
    }
  }

  void checkExistsPwdRequest() {
    bool pwdExists = xtmGlobalStore.auth.userInfo.initPassword;
    if (pwdExists) {
      changeRootPageAndLoginStatus();
    } else {
      pushToSettingPwdPage();
    }
  }

  void pushToSettingPwdPage() {
    UserInfoModel userInfo = xtmGlobalStore.auth.userInfo;
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return SettingPasswordPage(userId: userInfo.userID, mobile: _mobileController.text.trim());
    }));
  }

  void changeRootPageAndLoginStatus() async {
    Navigator.pushReplacementNamed(context, AppRouterNameConstant.MAIN);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countdownTimer.stop();
    super.dispose();
  }
}
