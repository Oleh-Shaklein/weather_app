import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import '../../data/services/localization_service.dart';
import 'weather_icon_widget.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherModel weather;
  final String temperatureUnit;
  final String language;

  const CurrentWeatherWidget({
    Key? key,
    required this.weather,
    this.temperatureUnit = 'C',
    this.language = 'en',
  }) : super(key: key);

  double _convertTemperature(double celsius) {
    if (temperatureUnit == 'F') {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  String _formatTemperature(double temp) {
    return '${_convertTemperature(temp).toStringAsFixed(0)}°${temperatureUnit}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // City Name
          Text(
            weather.city,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          // Weather Icon
          WeatherIconWidget(weatherIcon: weather.weatherIcon),
          const SizedBox(height: 16),
          // Current Temperature
          Text(
            _formatTemperature(weather.temperature),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            weather.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          // Feels Like
          Text(
            '${LocalizationService.translate('feels_like', language)} ${_formatTemperature(weather.feelsLike)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          // Temperature and Humidity Info
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoColumn(
                      label: LocalizationService.translate('max', language),
                      value: _formatTemperature(weather.maxTemp),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _InfoColumn(
                      label: LocalizationService.translate('min', language),
                      value: _formatTemperature(weather.minTemp),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _InfoColumn(
                      label: LocalizationService.translate('humidity', language),
                      value: '${weather.humidity}%',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoColumn(
                      label: LocalizationService.translate('wind', language),
                      value: '${weather.windSpeed.toStringAsFixed(1)} ${LocalizationService.translate('wind_speed_unit', language)}',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _InfoColumn(
                      label: LocalizationService.translate('pressure', language),
                      value: '${weather.pressure} hPa',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}