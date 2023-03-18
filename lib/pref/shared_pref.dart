import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

enum PerfKeys { langCode,name, email, loggedIn ,id}

class SharedPerfController {
  SharedPerfController._();

  late SharedPreferences _sharedPreferences;

  static SharedPerfController? _instance;

  factory SharedPerfController() {
    return _instance ??= SharedPerfController._();
  }

  Future<void> initShared() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void changeLanguage({required String langCode}) {
    _sharedPreferences.setString(PerfKeys.langCode.name, langCode);
  }

  void save({required User user}) {
    _sharedPreferences.setString(PerfKeys.name.name, user.name);
    _sharedPreferences.setInt(PerfKeys.id.name, user.id);
    _sharedPreferences.setString(PerfKeys.email.name, user.email);
    _sharedPreferences.setBool(PerfKeys.loggedIn.name, true);
  }

  T? getValue<T>(String key) {
    if (_sharedPreferences.containsKey(key)) {
      return _sharedPreferences.get(key) as T;
    }
    return null;
  }

  Future<bool> removeValueFor(String key) async {
    if (_sharedPreferences.containsKey(key)) {
      return _sharedPreferences.remove(key);
    }
    return false;
  }

  Future<bool> clean() async {
    return _sharedPreferences.clear();
  }

  bool get loggedIn =>
      _sharedPreferences.getBool(PerfKeys.loggedIn.name) ?? false;

  String get language =>
      _sharedPreferences.getString(PerfKeys.langCode.name) ?? 'en';
}
