import 'package:my_real_app/config/key_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

setDataToLocalStorage({
  String? dataType,
  String? prefKey,
  bool? boolData,
  double? doubleData,
  int? integerData,
  String? stringData,
  List<String>? listOfStringData,
}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  switch (dataType) {
    case StorageKey.boolType:
      return sharedPreferences.setBool(prefKey!, boolData!);
    case StorageKey.doubleType:
      return sharedPreferences.setDouble(prefKey!, doubleData!);
    case StorageKey.integerType:
      return sharedPreferences.setInt(prefKey!, integerData!);
    case StorageKey.stringType:
      return sharedPreferences.setString(prefKey!, stringData!);
    case StorageKey.listOfStringType:
      return sharedPreferences.setStringList(prefKey!, listOfStringData!);
    default:
      return null;
  }
}

getDataFromLocalStorage({
  String? dataType,
  String? prefKey,
}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  switch (dataType) {
    case StorageKey.boolType:
      return sharedPreferences.getBool(prefKey!);
    case StorageKey.doubleType:
      return sharedPreferences.getDouble(prefKey!);
    case StorageKey.integerType:
      return sharedPreferences.getInt(prefKey!);
    case StorageKey.stringType:
      return sharedPreferences.getString(prefKey!);
    case StorageKey.listOfStringType:
      return sharedPreferences.getStringList(prefKey!);
    default:
      return "fff";
  }
}

clearLocalStorage() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
}
