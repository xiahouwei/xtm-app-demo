import 'package:flutter_plugin_record_plus/flutter_plugin_record.dart';
import 'package:flutter_proj/utils/async_utils.dart';
import 'package:dio/dio.dart';

class XtmRecord {
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();

  String filePath = "";

  dynamic recorderPromise;

  bool isRecording = false;

  XtmRecord() {
    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    recordPlugin.response.listen((data) {
      if (data.msg == "onStop") {
        print("onStop  文件路径" + data.path);
        filePath = data.path;
        MultipartFile file = MultipartFile.fromFileSync(filePath);
        print(file);
        print("onStop  时长 " + data.audioTimeLength.toString());
        if (recorderPromise != null) {
          recorderPromise.complete(filePath);
        }
        recorderPromise = null;
      } else if (data.msg == "onStart") {
        print("onStart --");
      } else {
        print("--" + data.msg);
      }
    });

    recordPlugin.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg);
      print("振幅大小   " + voiceData.toString());
    });

    recordPlugin.responsePlayStateController.listen((data) {
      print("播放路径   " + data.playPath);
      print("播放状态   " + data.playState);
    });
  }

  void recordInit() async {
    recordPlugin.init();
  }

  void start() async {
    if (isRecording) {
      cancel();
    }
    isRecording = true;
    recordPlugin.start();
  }

  Future<String> stop() {
    return AsyncUtils.PromiseFunction<String>((promise) {
      isRecording = false;
      recorderPromise = promise;
      recordPlugin.stop();
    });
  }

  void cancel() async {
    isRecording = false;
    recordPlugin.stop();
  }

  void play() {
    recordPlugin.play();
  }

  void dispose() {
    recordPlugin.dispose();
  }
}

var xtmRecord = XtmRecord();
