import 'package:shared_preferences/shared_preferences.dart';

/**
 * 设置本地缓存
 */
setValue(key, value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  switch (value.runtimeType.toString()) {
    case "String":
      preferences.setString(key, value);
      break;
    case "int":
      preferences.setInt(key, value);
      break;
    case "bool":
      preferences.setBool(key, value);
      break;
    case "double":
      preferences.setDouble(key, value);
      break;
    case "List<String>":
      preferences.setStringList(key, value);
      break;
    default:
      break;
  }
}

/**
 * 获取本地缓存
 */
getValue(key, valueType, Function callback) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  switch (valueType) {
    case "String":
      callback(preferences.getString(key));
      break;
    case "int":
      callback(preferences.getInt(key));
      break;
    case "bool":
      callback(preferences.getBool(key));
      break;
    case "double":
      callback(preferences.getDouble(key));
      break;
    case "List<String>":
      callback(preferences.getStringList(key));
      break;
    default:
      break;
  }
}
