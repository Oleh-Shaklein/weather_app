import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/city_search_widget.dart';
import '../widgets/current_weather_widget.dart';
import '../widgets/forecast_list_widget.dart';
import '../widgets/saved_cities_widget.dart';
import '../widgets/offline_indicator_widget.dart';
import '../../providers/weather_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../utils/weather_time_helper.dart';
import 'settings_screen.dart';
///примітка: цього разу я обширно дав усьому терміни/назву файлів, зазвичай в мене спрощені назви типу wtr_pr чи cr_wtr

class MainWeatherScreen extends StatefulWidget {
  const MainWeatherScreen({Key? key}) : super(key: key);

  @override
  State<MainWeatherScreen> createState() => _MainWeatherScreenState();
}

class _MainWeatherScreenState extends State<MainWeatherScreen> {
  late List<Color> _currentGradientColors;

  @override
  void initState() {
    super.initState();
    _currentGradientColors = [Colors.blue[700]!, Colors.blue[300]!];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().init();
    });
  }

  void _updateGradientColors(WeatherProvider weatherProvider) {
    if (weatherProvider.enableTimeGradient &&
        weatherProvider.currentWeather != null) {
      final timezoneOffset = weatherProvider.currentWeather!.timezoneOffset;
      _currentGradientColors = WeatherTimeHelper.getGradientColorsByTime(
        DateTime.now(),
        timezoneOffset: timezoneOffset,
      );
    } else {
      _currentGradientColors = [Colors.blue[700]!, Colors.blue[300]!];
    }
  }

  void _openSettings(BuildContext context, WeatherProvider weatherProvider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          currentLanguage: weatherProvider.language,
          currentTemperatureUnit: weatherProvider.temperatureUnit,
          timeGradientEnabled: weatherProvider.enableTimeGradient,
          onLanguageChanged: (language) async {
            await weatherProvider.setLanguage(language);
          },
          onTemperatureUnitChanged: (unit) async {
            await weatherProvider.setTemperatureUnit(unit);
          },
          onTimeGradientChanged: (enabled) async {
            await weatherProvider.setTimeGradient(enabled);
            setState(() {
              _updateGradientColors(weatherProvider);
            });
          },
        ),
      ),
    ).then((_) {
      setState(() {
        _updateGradientColors(weatherProvider);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherProvider, ConnectivityProvider>(
      builder: (context, weatherProvider, connectivityProvider, _) {
        _updateGradientColors(weatherProvider);

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
              child: Stack(
                children: [
                  if (weatherProvider.isLoading)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  else if (weatherProvider.errorMessage != null)
                    _buildErrorWidget(context, weatherProvider)
                  else if (weatherProvider.currentWeather == null)
                      const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    else
                      Column(
                        children: [
                          _buildTopBar(context, weatherProvider),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  CurrentWeatherWidget(
                                    weather: weatherProvider.currentWeather!,
                                    temperatureUnit:
                                    weatherProvider.temperatureUnit,
                                    language: weatherProvider.language,
                                  ),
                                  // Saved Cities Widget
                                  if (weatherProvider.savedCities.isNotEmpty)
                                    const SavedCitiesWidget(),
                                  const SizedBox(height: 32),
                                  if (weatherProvider.forecastList.isNotEmpty)
                                    ForecastListWidget(
                                      forecast: weatherProvider.forecastList,
                                      temperatureUnit:
                                      weatherProvider.temperatureUnit,
                                      language: weatherProvider.language,
                                    ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  /// перевірка офлайну
                  if (!connectivityProvider.isOnline)
                    const OfflineIndicatorWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, WeatherProvider weatherProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: CitySearchWidget(
              onCityChanged: (city) {
                weatherProvider.loadWeatherByCity(city);
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () => _openSettings(context, weatherProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WeatherProvider weatherProvider) {
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
              'Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weatherProvider.errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  weatherProvider.loadWeatherByCity(weatherProvider.selectedCity),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}