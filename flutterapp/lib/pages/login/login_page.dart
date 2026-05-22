import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/common/h5_page/h5_url_manage.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/constants/login_constants.dart';
import 'package:flutter_proj/device/index.dart';
import 'package:flutter_proj/models/login/current_company_model.dart';
import 'package:flutter_proj/models/login/user_company_model.dart';
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> _mobileKey = GlobalKey<FormFieldState>();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  CountdownTimerUtil _countdownTimer = CountdownTimerUtil();
  AnimationController _animationController;
  Animation<double> _animation;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  int hardwareInformationMaxLength = 50;

  @override
  void initState() {
    super.initState();
    initBgAnimation();
    initInputDefaultValue();
    initVersionCode();
    checkVersion();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      agreementHandler();
    });
  }

  void initBgAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_animationController);
  }

  void checkVersion() {
    xtmApi.auth.checkVersion();
  }

  void initInputDefaultValue() {
    String userName = xtmGlobalStore.auth.userName;
    String password = xtmGlobalStore.auth.password;
    setState(() {
      _mobileController.text = userName;
      if (_loginType == LoginConstants.LOGIN_TYPE_MOBILE) {
        _pwdController.text = password;
      }
    });
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
          buildContentWidget(),
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
            initialScale: 0.5,
          ),
        );
      },
    );
  }

  Widget buildContentWidget() {
    return Column(
      children: [
        Expanded(child: displayBodyContent()),
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
            SizedBox(height: 80),
            _buildLoginTitle(),
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

  Widget _buildLoginTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/login/image_login_logo.png',
          height: 40,
          fit: BoxFit.fitHeight,
        ),
        const SizedBox(height: 40),
        Image.asset(
          'assets/images/login/image_login_title.png',
          height: 45,
          fit: BoxFit.fitHeight,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Image.asset(
              'assets/images/login/image_login_sub_title.png',
              height: 28,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/login/image_login_des.png',
              height: 25,
              fit: BoxFit.fitHeight,
            ),
            Transform.translate(
              offset: const Offset(0, 1),
              child: Image.asset(
                'assets/images/login/image_login_des_icon.png',
                width: 20,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ],
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
    String hardwareInformation = await getDeviceInfo();
    xtmGlobalStore.auth.setToken(HTTPConfig.baseToken);
    Map<String, dynamic> loginParam = {};
    loginParam['mobile'] = _mobileController.text.trim();
    loginParam['password'] = _pwdController.text.trim();
    loginParam['messageCode'] = _smsCodeController.text.trim();
    loginParam['loginTypeCode'] = _loginType;
    loginParam['hardwareInformation'] = hardwareInformation;
    xtmApi.auth.loginByMobile(params: loginParam).then((res) => handleToken(res));
  }

  Future<String> getDeviceInfo() async {
    String hardwareInformation = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      hardwareInformation = '${androidInfo.manufacturer}__${androidInfo.model}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      hardwareInformation =
          '${iosInfo.model}__${iosInfo.utsname.machine}__${iosInfo.systemName}__${iosInfo.systemVersion}';
    }
    if (hardwareInformation.length > hardwareInformationMaxLength) {
      return hardwareInformation.substring(0, hardwareInformationMaxLength);
    }
    return hardwareInformation;
  }

  void handleToken(Map<String, dynamic> res) async {
    var token = res['header']['token'];
    if (token != null) {
      xtmGlobalStore.auth.setToken(token);
    }
    handleUserInfo(res['body']['content']['userInfo']);
    chooseCurrentCompany().then((value) {
      xtmGlobalStore.auth.setIsLogin(true);
      bindGpushClientId();
      loginStatusSetting();
    });
  }

  Future<void> chooseCurrentCompany() {
    return AsyncUtils.PromiseFunction<String>((promise) async {
      xtmApi.auth.getManageCompanyList().then((res) async {
        UserCompanyListModel response = UserCompanyListModel.fromJson(res);
        List<UserCompanyModel> companyList = response.list;
        if (companyList.isEmpty) {
          CompanyInfo defaultCompany = xtmGlobalStore.auth.userInfo.companyInfo;
          xtmGlobalStore.auth.setCurrentCompanyId(defaultCompany.companyID);
          xtmGlobalStore.auth.setCurrentCompanyInfo(
            CurrentCompanyModel.fromJson(defaultCompany.toJson()),
          );
          promise.complete();
        }
        if (companyList.length == 1) {
          xtmGlobalStore.auth.setCurrentCompanyId(companyList.first.id);
          await _getSelectCompanyInfo(companyList.first.id);
          promise.complete();
        }
        List<String> companyNameList = companyList.map((item) => item.name).toList();
        XtmBottomSheet.showBottomPicker(
          context,
          title: '选择登录企业',
          data: companyNameList,
          selectItem: '',
        ).then((index) async {
          xtmGlobalStore.auth.setCurrentCompanyId(companyList[index].id);
          await _getSelectCompanyInfo(companyList[index].id);
          promise.complete();
        });
      });
    });
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

  // 获取所选企业信息
  Future<void> _getSelectCompanyInfo(String companyId) {
    return AsyncUtils.PromiseFunction<String>((promise) async {
      xtmApi.auth.getCurrentCompanyInfo(companyId).then((value) {
        CurrentCompanyModel companyInfo = CurrentCompanyModel.fromJson(value);
        xtmGlobalStore.auth.setCurrentCompanyInfo(companyInfo);
        promise.complete();
      });
    });
  }

  void bindGpushClientId() {
    xtmApi.auth.bindClientId();
  }

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
