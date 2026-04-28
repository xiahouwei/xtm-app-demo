/// 步进器模型
class StepInfoModel {
  final String stepType;
  final String stepDesc;
  int stepState;

  /// 是否可选，默认为true
  bool stepEnable;

  StepInfoModel({
    this.stepType,
    this.stepDesc,
    this.stepState,
    this.stepEnable = true,
  });
}

class UploadStepState {
  static const int stepStateWait = 1;
  static const int stepStateUploaded = 2;
  static const int stepStateUnSelect = 3;
  static const int stepStateSelected = 4;
  static const int stepStateUnSign = 5;
  static const int stepStateSigned = 6;
  static const int stepStateUnWrite = 7;
  static const int stepStateWritten = 8;

  static String stepStateStr(int state) {
    String stateStr = '';
    switch (state) {
      case stepStateWait:
        stateStr = '待上传';
        break;
      case stepStateUploaded:
        stateStr = '已上传';
        break;
      case stepStateUnSelect:
        stateStr = '待选择';
        break;
      case stepStateSelected:
        stateStr = '已选择';
        break;
      case stepStateUnSign:
        stateStr = '待签约';
        break;
      case stepStateSigned:
        stateStr = '已签约';
        break;
      case stepStateUnWrite:
        stateStr = '待填写';
        break;
      case stepStateWritten:
        stateStr = '已填写';
        break;
    }
    return stateStr;
  }
}
