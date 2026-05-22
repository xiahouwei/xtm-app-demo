import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static set(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is List) {
      prefs.setStringList(key, value.cast<String>());
    }
  }

  /// 返回数据data -> replace -> null
  static Future<String> get(String key, String defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get(key);
    return (data == null || data.toString().isEmpty) ? '' : data.toString();
  }

  static Future<int> getInt(String key, int defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get(key);
    if (data != null) {
      return data;
    }
    return defaultValue;
  }

  static Future<double> getDouble(String key, double defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get(key);
    if (data != null) {
      return data;
    }
    return defaultValue;
  }

  static Future<List> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getStringList(key);
    return data ?? [];
  }

  static Future<bool> getBool(String key, var replace) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = prefs.get(key);
      return (data == null || data.toString().isEmpty) ? replace : data;
    } catch (e) {
      return Future.value(false);
    }
  }

  static remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static removeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
