import 'package:shared_preferences/shared_preferences.dart';

class OfflineModeService {
  static const String key = 'is_offline_mode';

  final SharedPreferences _prefs;

  OfflineModeService(this._prefs);

  bool get isOfflineMode => _prefs.getBool(key) ?? false;

  Future<void> setOfflineMode(bool value) async {
    await _prefs.setBool(key, value);
  }
}
