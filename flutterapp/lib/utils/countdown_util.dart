import 'dart:async';

import 'package:flutter/foundation.dart';

class CountdownTimerUtil {
  /// 定时器
  Timer _timer;

  int _duration = 60;

  /// 当前剩余秒数
  final ValueNotifier<int> _remainingSeconds = ValueNotifier<int>(0);

  ValueListenable<int> get remainingSeconds => _remainingSeconds;

  bool get isCounting => _remainingSeconds.value > 0;

  /// 启动倒计时
  void start({int duration = 60}) {
    if (isCounting) return;

    _duration = duration;
    _remainingSeconds.value = _duration;

    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value -= 1;
        print('Remaining seconds: ${_remainingSeconds.value}');
      } else {
        print('Countdown cancel');
        timer.cancel();
        _timer = null;
      }
    });
  }

  /// 手动停止倒计时（重置为0）
  void stop() {
    _timer?.cancel();
    _timer = null;
    _remainingSeconds.value = 0;
  }

  /// 获取当前是否可发送验证码（即倒计时是否结束）
  bool get canSend => !isCounting;

  String get displayText {
    if (isCounting) {
      return '${_remainingSeconds.value}s后重发';
    } else {
      return '获取验证码';
    }
  }
}
