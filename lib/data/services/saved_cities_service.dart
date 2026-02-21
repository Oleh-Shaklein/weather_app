import 'package:shared_preferences/shared_preferences.dart';

class SavedCitiesService {
  static const String _savedCitiesKey = 'saved_cities';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<String>> getSavedCities() async {
    return _prefs.getStringList(_savedCitiesKey) ?? [];
  }

  Future<void> addCity(String city) async {
    final cities = await getSavedCities();
    if (!cities.contains(city)) {
      cities.add(city);
      await _prefs.setStringList(_savedCitiesKey, cities);
    }
  }

  Future<void> removeCity(String city) async {
    final cities = await getSavedCities();
    cities.remove(city);
    await _prefs.setStringList(_savedCitiesKey, cities);
  }

  Future<bool> isCitySaved(String city) async {
    final cities = await getSavedCities();
    return cities.contains(city);
  }
}