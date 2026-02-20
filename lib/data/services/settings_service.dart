import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _languageKey = 'language';
  static const String _temperatureUnitKey = 'temperatureUnit';
  static const String _timeGradientKey = 'timeGradient';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Language
  String getLanguage() => _prefs.getString(_languageKey) ?? 'en';

  Future<void> setLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

  // Temperature Unit
  String getTemperatureUnit() => _prefs.getString(_temperatureUnitKey) ?? 'C';

  Future<void> setTemperatureUnit(String unit) async {
    await _prefs.setString(_temperatureUnitKey, unit);
  }

  // Time Gradient
  bool isTimeGradientEnabled() => _prefs.getBool(_timeGradientKey) ?? true;

  Future<void> setTimeGradientEnabled(bool enabled) async {
    await _prefs.setBool(_timeGradientKey, enabled);
  }
}