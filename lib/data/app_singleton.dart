import 'package:project_care_app/data/local/keychain/shared_prefs.dart';
import 'package:project_care_app/data/local/keychain/shared_prefs_key.dart';

import '../di/injection.dart';

class AppSingleton {
  factory AppSingleton() {
    return _singleton;
  }

  AppSingleton._internal();

  static AppSingleton get instance => AppSingleton();

  static final AppSingleton _singleton = AppSingleton._internal();

  final SharedPrefs _sharedPrefs = getIt<SharedPrefs>();

  String? get accessToken => _sharedPrefs.get(SharedPrefsKey.token);

  bool get isLogin => _sharedPrefs.get(SharedPrefsKey.loginState) ?? false;

  String? get studyID => _sharedPrefs.get(SharedPrefsKey.studyID);

  set studyID(String? value) {
    _sharedPrefs.put(SharedPrefsKey.studyID, value);
  }

  set isLogin(bool value) {
    _sharedPrefs.put(SharedPrefsKey.loginState, value);
  }
}
