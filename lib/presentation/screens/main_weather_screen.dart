import 'package:flutter/material.dart';
import '../widgets/city_search_widget.dart';
import '../widgets/current_weather_widget.dart';
import '../widgets/forecast_list_widget.dart';
import '../../data/models/weather_model.dart';
import '../../data/services/weather_service.dart';
import '../../data/services/settings_service.dart';
import '../../data/services/localization_service.dart';
import '../../utils/weather_time_helper.dart';
import 'settings_screen.dart';

class MainWeatherScreen extends StatefulWidget {
  const MainWeatherScreen({Key? key}) : super(key: key);

  @override
  State<MainWeatherScreen> createState() => _MainWeatherScreenState();
}

class _MainWeatherScreenState extends State<MainWeatherScreen> {
  String _selectedCity = 'London';
  WeatherModel? _currentWeather;
  List<ForecastDay> _forecastList = [];
  final WeatherService _weatherService = WeatherService();
  final SettingsService _settingsService = SettingsService();
  bool _isLoading = false;
  String? _errorMessage;
  String _language = 'en';
  String _temperatureUnit = 'C';
  bool _enableTimeGradient = true;
  late List<Color> _currentGradientColors;

  @override
  void initState() {
    super.initState();
    // Initialize gradient colors first
    _currentGradientColors = [Colors.blue[700]!, Colors.blue[300]!];
    _initializeSettings();
  }

  void _initializeSettings() async {
    await _settingsService.init();
    setState(() {
      _language = _settingsService.getLanguage();
      _temperatureUnit = _settingsService.getTemperatureUnit();
      _enableTimeGradient = _settingsService.isTimeGradientEnabled();
    });
    _loadWeatherData();
    _loadUserLocation();
  }

  void _updateGradientColors() {
    if (_enableTimeGradient && _currentWeather != null) {
      // Use timezone offset from current weather if available
      final timezoneOffset = _currentWeather!.timezoneOffset;
      _currentGradientColors = WeatherTimeHelper.getGradientColorsByTime(
        DateTime.now(),
        timezoneOffset: timezoneOffset,
      );
    } else {
      _currentGradientColors = [Colors.blue[700]!, Colors.blue[300]!];
    }
  }

  void _loadUserLocation() async {
    try {
      final position = await _weatherService.getCurrentLocation();
      print('User location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Location error: $e');
    }
  }

  void _loadWeatherData() {
    _loadWeatherByCity(_selectedCity);
  }

  void _loadWeatherByCity(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.getWeatherByCity(city);
      final forecast = await _weatherService.getForecast(city);

      setState(() {
        _currentWeather = weather;
        _forecastList = forecast;
        _selectedCity = city;
        _isLoading = false;
        _updateGradientColors();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _onCityChanged(String newCity) {
    if (newCity.isNotEmpty) {
      _loadWeatherByCity(newCity);
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          currentLanguage: _language,
          currentTemperatureUnit: _temperatureUnit,
          timeGradientEnabled: _enableTimeGradient,
          onLanguageChanged: (language) async {
            await _settingsService.setLanguage(language);
            setState(() {
              _language = language;
            });
          },
          onTemperatureUnitChanged: (unit) async {
            await _settingsService.setTemperatureUnit(unit);
            setState(() {
              _temperatureUnit = unit;
            });
          },
          onTimeGradientChanged: (enabled) async {
            await _settingsService.setTimeGradientEnabled(enabled);
            setState(() {
              _enableTimeGradient = enabled;
              _updateGradientColors();
            });
          },
        ),
      ),
    ).then((_) {
      // Rebuild when returning from settings
      setState(() {
        _language = _settingsService.getLanguage();
        _temperatureUnit = _settingsService.getTemperatureUnit();
        _enableTimeGradient = _settingsService.isTimeGradientEnabled();
        _updateGradientColors();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _currentGradientColors,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
              : _errorMessage != null
              ? _buildErrorWidget()
              : _currentWeather == null
              ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
              : Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CurrentWeatherWidget(
                        weather: _currentWeather!,
                        temperatureUnit: _temperatureUnit,
                        language: _language,
                      ),
                      const SizedBox(height: 32),
                      if (_forecastList.isNotEmpty)
                        ForecastListWidget(
                          forecast: _forecastList,
                          temperatureUnit: _temperatureUnit,
                          language: _language,
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: CitySearchWidget(onCityChanged: _onCityChanged),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: _openSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              LocalizationService.translate('error', _language),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadWeatherData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text(
                LocalizationService.translate('retry', _language),
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}