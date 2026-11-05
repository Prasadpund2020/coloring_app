import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({required this.soundEnabled});

  final bool soundEnabled;
}

class AppSettingsRepository {
  const AppSettingsRepository(this._preferences);

  static const String _soundEnabledKey = 'sound_enabled';

  final SharedPreferences _preferences;

  AppSettings load() {
    return AppSettings(
      soundEnabled: _preferences.getBool(_soundEnabledKey) ?? true,
    );
  }

  Future<void> setSoundEnabled(bool enabled) {
    return _preferences.setBool(_soundEnabledKey, enabled);
  }
}
