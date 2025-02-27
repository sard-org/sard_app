import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: must_be_immutable
class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreferences Initialized');
  }

  /// Will clear all the data stored in preferences
  Future<void> clearPreferencesData() async {
    await _sharedPreferences?.clear();
  }

  Future<void> setThemeData(String value) async {
    await _sharedPreferences?.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences?.getString("themeData") ?? 'primary';
    } catch (e) {
      return 'primary';
    }
  }
}
