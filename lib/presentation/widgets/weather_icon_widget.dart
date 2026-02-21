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
    const iconMap = {
      '01d': Icons.wb_sunny,
      '02d': Icons.wb_cloudy,
      '03d': Icons.cloud,
      '04d': Icons.cloud,
      '09d': Icons.grain,
      '10d': Icons.cloud_queue,
      '11d': Icons.flash_on,
      '13d': Icons.ac_unit,
      '50d': Icons.cloud,
    };

    final iconData = iconMap[icon] ?? Icons.cloud;

    return Icon(
      iconData,
      size: 64,
      color: Colors.white,
    );
  }
}