import 'package:flutter/material.dart';
import '../data/models/weather_model.dart';
import '../data/services/weather_service.dart';
import '../data/services/settings_service.dart';
import '../data/services/saved_cities_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final SettingsService _settingsService = SettingsService();
  final SavedCitiesService _savedCitiesService = SavedCitiesService();

  WeatherModel? _currentWeather;
  List<ForecastDay> _forecastList = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCity = 'London';
  String _language = 'en';
  String _temperatureUnit = 'C';
  bool _enableTimeGradient = true;
  List<String> _savedCities = [];
  bool _isCurrentCitySaved = false;

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastDay> get forecastList => _forecastList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCity => _selectedCity;
  String get language => _language;
  String get temperatureUnit => _temperatureUnit;
  bool get enableTimeGradient => _enableTimeGradient;
  List<String> get savedCities => _savedCities;
  bool get isCurrentCitySaved => _isCurrentCitySaved;

  Future<void> init() async {
    await _settingsService.init();
    await _savedCitiesService.init();
    _language = _settingsService.getLanguage();
    _temperatureUnit = _settingsService.getTemperatureUnit();
    _enableTimeGradient = _settingsService.isTimeGradientEnabled();
    await _loadSavedCities();
    notifyListeners();
    await loadWeatherByCity(_selectedCity);
  }

  Future<void> _loadSavedCities() async {
    _savedCities = await _savedCitiesService.getSavedCities();
    notifyListeners();
  }

  Future<void> loadWeatherByCity(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final weather = await _weatherService.getWeatherByCity(city);
      final forecast = await _weatherService.getForecast(city);

      _currentWeather = weather;
      _forecastList = forecast;
      _selectedCity = city;
      _isCurrentCitySaved = await _savedCitiesService.isCitySaved(city);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleSaveCity(String city) async {
    final isSaved = await _savedCitiesService.isCitySaved(city);
    if (isSaved) {
      await _savedCitiesService.removeCity(city);
    } else {
      await _savedCitiesService.addCity(city);
    }
    await _loadSavedCities();
    _isCurrentCitySaved = !isSaved;
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    await _settingsService.setLanguage(language);
    notifyListeners();
  }

  Future<void> setTemperatureUnit(String unit) async {
    _temperatureUnit = unit;
    await _settingsService.setTemperatureUnit(unit);
    notifyListeners();
  }

  Future<void> setTimeGradient(bool enabled) async {
    _enableTimeGradient = enabled;
    await _settingsService.setTimeGradientEnabled(enabled);
    notifyListeners();
  }
}