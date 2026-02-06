import 'package:flutter_proj/constants/base/bottom_sheet_base.dart';
import 'package:flutter_proj/models/widget/bottom_list_model.dart';

/// 排放标准
class EmissionStandardConstants extends BottomSheetBase {
  static const String GUO_4 = "1011001";
  static const String GUO_5 = "1011002";
  static const String GUO_6 = "1011003";
  static const String WU = "1011004";

  static const List<String> BOTTOM_SHEET_KEY = [GUO_4, GUO_5, GUO_6];

  static String getEmissionText(String code) {
    switch (code) {
      case GUO_4:
        return "国四";
      case GUO_5:
        return "国五";
      case GUO_6:
        return "国六";
      case WU:
        return "无";
      default:
        return "";
    }
  }

  @override
  String getSheetItemName(key) => getEmissionText(key);

  @override
  List<BottomListModel> get sheetModelList => getSheetModelList(BOTTOM_SHEET_KEY);

  @override
  List<String> get sheetNames => getSheetNames(BOTTOM_SHEET_KEY);
}

/// 卸车方式
class UnloadTypeConstants extends BottomSheetBase {
  /// 非自卸
  static const int NO_SELF = 0;

  /// 自卸
  static const int SELF = 1;

  /// 半自卸
  static const int SEMI_SELF = 2;

  static const List<int> BOTTOM_SHEET_KEY = [NO_SELF, SELF, SEMI_SELF];

  static String getUnloadTypeText(int code) {
    switch (code) {
      case NO_SELF:
        return "非自卸";
      case SELF:
        return "自卸";
      case SEMI_SELF:
        return "半自卸";
      default:
        return "非自卸";
    }
  }

  @override
  String getSheetItemName(key) => getUnloadTypeText(key);

  @override
  List<BottomListModel> get sheetModelList => getSheetModelList(BOTTOM_SHEET_KEY);

  @override
  List<String> get sheetNames => getSheetNames(BOTTOM_SHEET_KEY);
}

/// 车辆类型
class VehicleTypeConstants extends BottomSheetBase {
  /// 重型半挂牵引车
  static const String HEAVY_DUTY_SEMI_TRAILER_TRACTOR = "1891394306365517827";

  /// 重型全挂牵引车
  static const String HEAVY_DUTY_FULL_TRAILER_TRACTOR = "1891394306365517828";

  /// 中型厢式货车
  static const String MEDIUM_SIZED_BOX_VAN = "1891394306365517830";

  /// 重型仓栅式货车
  static const String HEAVY_DUTY_CAGE_TRUCK = "1891394306365517831";

  /// 重型罐式货车
  static const String HEAVY_DUTY_TANK_TRUCK = "1891394306365517832";

  /// 重型栏板货车
  static const String HEAVY_DUTY_BOARD_TRUCK = "1891394306365517833";

  /// 重型平板货车
  static const String HEAVY_DUTY_FLATBED_TRUCK = "1891394306365517834";

  /// 重型普通货车
  static const String HEAVY_DUTY_ORDINARY_TRUCK = "1891394306365517835";

  /// 重型特殊结构货车
  static const String HEAVY_DUTY_SPECIAL_STRUCTURE_TRUCKS = "1891394306365517836";

  /// 重型厢式货车
  static const String HEAVY_DUTY_BOX_VAN = "1891394306365517837";

  /// 重型自卸货车
  static const String HEAVY_DUTY_DUMP_TRUCK = "1891394306365517838";

  /// 重型仓栅式半挂车
  static const String HEAVY_DUTY_CAGE_SEMI_TRAILER = "1891394306365517840";

  /// 重型仓栅式全挂车
  static const String HEAVY_DUTY_CAGE_FULL_TRAILER = "1891394306365517841";

  /// 重型车辆运输半挂车
  static const String HEAVY_VEHICLE_TRANSPORT_SEMI_TRAILER = "1891394306365517842";

  /// 重型罐式半挂车
  static const String HEAVY_DUTY_TANK_SEMI_TRAILER = "1891394306365517843";

  /// 重型集装箱半挂车
  static const String HEAVY_DUTY_CONTAINER_SEMI_TRAILER = "1891394306365517844";

  /// 重型栏板半挂车
  static const String HEAVY_DUTY_BOARD_SEMI_TRAILER = "1891394306365517845";

  /// 重型平板半挂车
  static const String HEAVY_DUTY_FLATBED_SEMI_TRAILER = "1891394306365517846";

  /// 重型普通半挂车
  static const String HEAVY_DUTY_ORDINARY_SEMI_TRAILER = "1891394306365517847";

  /// 重型特殊结构半挂车
  static const String HEAVY_DUTY_SPECIAL_STRUCTURE_SEMI_TRAILER = "1891394306365517848";

  /// 重型厢式半挂车
  static const String HEAVY_DUTY_BOX_SEMI_TRAILER = "1891394306365517849";

  /// 重型自卸半挂车
  static const String HEAVY_DUTY_DUMP_SEMI_TRAILER = "1891394306365517850";

  /// 重型特殊结构自卸半挂车
  static const String HEAVY_DUTY_SPECIAL_STRUCTURE_DUMP_SEMI_TRAILER = "1968943627945799681";

  static const List<String> BOTTOM_SHEET_KEY = [
    HEAVY_DUTY_SEMI_TRAILER_TRACTOR,
    HEAVY_DUTY_FULL_TRAILER_TRACTOR,
    MEDIUM_SIZED_BOX_VAN,
    HEAVY_DUTY_CAGE_TRUCK,
    HEAVY_DUTY_TANK_TRUCK,
    HEAVY_DUTY_BOARD_TRUCK,
    HEAVY_DUTY_FLATBED_TRUCK,
    HEAVY_DUTY_ORDINARY_TRUCK,
    HEAVY_DUTY_SPECIAL_STRUCTURE_TRUCKS,
    HEAVY_DUTY_BOX_VAN,
    HEAVY_DUTY_DUMP_TRUCK,
    HEAVY_DUTY_CAGE_SEMI_TRAILER,
    HEAVY_DUTY_CAGE_FULL_TRAILER,
    HEAVY_VEHICLE_TRANSPORT_SEMI_TRAILER,
    HEAVY_DUTY_TANK_SEMI_TRAILER,
    HEAVY_DUTY_CONTAINER_SEMI_TRAILER,
    HEAVY_DUTY_BOARD_SEMI_TRAILER,
    HEAVY_DUTY_FLATBED_SEMI_TRAILER,
    HEAVY_DUTY_ORDINARY_SEMI_TRAILER,
    HEAVY_DUTY_SPECIAL_STRUCTURE_SEMI_TRAILER,
    HEAVY_DUTY_BOX_SEMI_TRAILER,
    HEAVY_DUTY_DUMP_SEMI_TRAILER,
    HEAVY_DUTY_SPECIAL_STRUCTURE_DUMP_SEMI_TRAILER,
  ];

  static String getVehicleTypeText(String code) {
    switch (code) {
      case HEAVY_DUTY_SEMI_TRAILER_TRACTOR:
        return "重型半挂牵引车";
      case HEAVY_DUTY_FULL_TRAILER_TRACTOR:
        return "重型全挂牵引车";
      case MEDIUM_SIZED_BOX_VAN:
        return "中型厢式货车";
      case HEAVY_DUTY_CAGE_TRUCK:
        return "重型仓栅式货车";
      case HEAVY_DUTY_TANK_TRUCK:
        return "重型罐式货车";
      case HEAVY_DUTY_BOARD_TRUCK:
        return "重型栏板货车";
      case HEAVY_DUTY_FLATBED_TRUCK:
        return "重型平板货车";
      case HEAVY_DUTY_ORDINARY_TRUCK:
        return "重型普通货车";
      case HEAVY_DUTY_SPECIAL_STRUCTURE_TRUCKS:
        return "重型特殊结构货车";
      case HEAVY_DUTY_BOX_VAN:
        return "重型厢式货车";
      case HEAVY_DUTY_DUMP_TRUCK:
        return "重型自卸货车";
      case HEAVY_DUTY_CAGE_SEMI_TRAILER:
        return "重型仓栅式半挂车";
      case HEAVY_DUTY_CAGE_FULL_TRAILER:
        return "重型仓栅式全挂车";
      case HEAVY_VEHICLE_TRANSPORT_SEMI_TRAILER:
        return "重型车辆运输半挂车";
      case HEAVY_DUTY_TANK_SEMI_TRAILER:
        return "重型罐式半挂车";
      case HEAVY_DUTY_CONTAINER_SEMI_TRAILER:
        return "重型集装箱半挂车";
      case HEAVY_DUTY_BOARD_SEMI_TRAILER:
        return "重型栏板半挂车";
      case HEAVY_DUTY_FLATBED_SEMI_TRAILER:
        return "重型平板半挂车";
      case HEAVY_DUTY_ORDINARY_SEMI_TRAILER:
        return "重型普通半挂车";
      case HEAVY_DUTY_SPECIAL_STRUCTURE_SEMI_TRAILER:
        return "重型特殊结构半挂车";
      case HEAVY_DUTY_BOX_SEMI_TRAILER:
        return "重型厢式半挂车";
      case HEAVY_DUTY_DUMP_SEMI_TRAILER:
        return "重型自卸半挂车";
      case HEAVY_DUTY_SPECIAL_STRUCTURE_DUMP_SEMI_TRAILER:
        return "重型特殊结构自卸半挂车";
      default:
        return "";
    }
  }

  @override
  String getSheetItemName(key) => getVehicleTypeText(key);

  @override
  List<BottomListModel> get sheetModelList => getSheetModelList(BOTTOM_SHEET_KEY);

  @override
  List<String> get sheetNames => getSheetNames(BOTTOM_SHEET_KEY);
}

/// 车辆能源类型
class EnergyTypeConstants extends BottomSheetBase {
  /// 汽油
  static const String GASOLINE = "4340010";

  /// 柴油
  static const String DIESEL = "4340020";

  /// 电(电能驱动)
  static const String BEV = "4340030";

  /// 混合油
  static const String MIXTURE_OIL = "4340040";

  /// 天然气
  static const String NATURAL_GAS = "4340050";

  /// 液化石油气
  static const String LPG = "4340060";

  /// 甲醇
  static const String METHYL_ALCOHOL = "4340070";

  /// 乙醇
  static const String ETHYL_ALCOHOL = "4340080";

  /// 太阳能
  static const String SOLAR = "4340090";

  /// 混合动力
  static const String HEV = "4340100";

  /// 无（无动力）
  static const String NONE = "4340110";

  /// 其他
  static const String OTHER = "4340120";

  static const List<String> BOTTOM_SHEET_KEY = [
    GASOLINE,
    DIESEL,
    BEV,
    MIXTURE_OIL,
    NATURAL_GAS,
    LPG,
    METHYL_ALCOHOL,
    ETHYL_ALCOHOL,
    SOLAR,
    HEV,
    NONE,
    OTHER
  ];

  static String getEnergyTypeText(String code) {
    switch (code) {
      case GASOLINE:
        return "汽油";
      case DIESEL:
        return "柴油";
      case BEV:
        return "电(电能驱动)";
      case MIXTURE_OIL:
        return "混合油";
      case NATURAL_GAS:
        return "天然气";
      case LPG:
        return "液化石油气";
      case METHYL_ALCOHOL:
        return "甲醇";
      case ETHYL_ALCOHOL:
        return "乙醇";
      case SOLAR:
        return "太阳能";
      case HEV:
        return "混合动力";
      case NONE:
        return "无（无动力）";
      case OTHER:
      default:
        return "";
    }
  }

  @override
  String getSheetItemName(key) => getEnergyTypeText(key);

  @override
  List<BottomListModel> get sheetModelList => getSheetModelList(BOTTOM_SHEET_KEY);

  @override
  List<String> get sheetNames => getSheetNames(BOTTOM_SHEET_KEY);
}

/// 车牌颜色
class VehicleCodeColorConstants extends BottomSheetBase {
  /// 蓝色
  static const String BLUE = "4280010";

  /// 黄色
  static const String YELLOW = "4280020";

  /// 黑色
  static const String BLACK = "4280030";

  /// 白色
  static const String WHITE = "4280040";

  /// 绿色
  static const String GREEN = "4280050";

  /// 农黄色
  static const String GINGER = "4280070";

  /// 农绿色
  static const String CGAN = "4280080";

  /// 黄绿色
  static const String KELLY = "4280090";

  /// 渐变绿
  static const String TINT_GREEN = "4280100";

  /// 其他
  static const String OTHER = "4280060";

  static const List<String> BOTTOM_SHEET_KEY = [
    BLUE,
    YELLOW,
    BLACK,
    WHITE,
    GREEN,
    GINGER,
    CGAN,
    KELLY,
    TINT_GREEN,
    OTHER
  ];

  static String getVehicleCodeColorText(String code) {
    switch (code) {
      case BLUE:
        return "蓝色";
      case YELLOW:
        return "黄色";
      case BLACK:
        return "黑色";
      case WHITE:
        return "白色";
      case GREEN:
        return "绿色";
      case GINGER:
        return "农黄色";
      case CGAN:
        return "农绿色";
      case KELLY:
        return "黄绿色";
      case TINT_GREEN:
        return "渐变绿";
      case OTHER:
      default:
        return "其他";
    }
  }

  @override
  String getSheetItemName(key) => getVehicleCodeColorText(key);

  @override
  List<BottomListModel> get sheetModelList => getSheetModelList(BOTTOM_SHEET_KEY);

  @override
  List<String> get sheetNames => getSheetNames(BOTTOM_SHEET_KEY);
}
