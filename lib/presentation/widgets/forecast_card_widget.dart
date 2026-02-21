import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import '../../data/services/localization_service.dart';
import 'weather_icon_widget.dart';

class ForecastCardWidget extends StatelessWidget {
  final ForecastDay day;
  final ForecastDay? previousDay;
  final String temperatureUnit;
  final String language;

  const ForecastCardWidget({
    Key? key,
    required this.day,
    this.previousDay,
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
    return '${_convertTemperature(temp).toStringAsFixed(0)}°';
  }

  int _getTemperatureChange() {
    if (previousDay == null) return 0;
    return (_convertTemperature(day.temperature) -
        _convertTemperature(previousDay!.temperature))
        .toInt();
  }

  Widget _buildTemperatureIndicator() {
    final change = _getTemperatureChange();
    if (change == 0) {
      return const Icon(Icons.trending_flat, color: Colors.white, size: 12);
    } else if (change > 0) {
      return Tooltip(
        message: '+$change°',
        child: const Icon(Icons.trending_up, color: Colors.red, size: 12),
      );
    } else {
      return Tooltip(
        message: '$change°',
        child: const Icon(Icons.trending_down, color: Colors.blue, size: 12),
      );
    }
  }

  String _getWeatherDescription() {
    if (day.cloudiness > 70) {
      return LocalizationService.translate('cloudy', language);
    }
    if (day.cloudiness > 40) {
      return LocalizationService.translate('partly_cloudy', language);
    }
    return LocalizationService.translate('clear', language);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              day.dayOfWeek,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Center(
              child: WeatherIconWidget(weatherIcon: day.weatherIcon),
            ),
          ),
          ///температурний індикатор - зміна по стрілочкам збоку
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTemperature(day.temperature),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 3),
              _buildTemperatureIndicator(),
            ],
          ),
          SizedBox(
            height: 28,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Center(
                child: Text(
                  _getWeatherDescription(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocalizationService.translate('humidity_icon', language),
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(width: 2),
                Text(
                  '${day.humidity}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}