import 'package:flutter/material.dart';

class WeatherIconWidget extends StatelessWidget {
  final String weatherIcon;

  const WeatherIconWidget({
    Key? key,
    required this.weatherIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getWeatherIcon(weatherIcon);
  }

  Widget _getWeatherIcon(String icon) {
    // Weather icon codes mapping
    const iconMap = {
      '01d': Icons.wb_sunny,        // Clear sky
      '02d': Icons.wb_cloudy,       // Few clouds
      '03d': Icons.cloud,           // Scattered clouds
      '04d': Icons.cloud,           // Broken clouds
      '09d': Icons.grain,           // Shower rain
      '10d': Icons.cloud_queue,     // Rain
      '11d': Icons.flash_on,        // Thunderstorm
      '13d': Icons.ac_unit,         // Snow
      '50d': Icons.cloud,           // Mist
    };

    final iconData = iconMap[icon] ?? Icons.cloud;

    return Icon(
      iconData,
      size: 64,
      color: Colors.white,
    );
  }
}