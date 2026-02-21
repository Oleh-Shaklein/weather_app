import 'package:flutter/material.dart';

class WeatherTimeHelper {
  static List<Color> getGradientColorsByTime(
      DateTime dateTime, {
        int timezoneOffset = 0,
      }) {
    /// перевірка по часовим поясам
    final adjustedTime = dateTime.add(Duration(seconds: timezoneOffset));
    final hour = adjustedTime.hour;

    /// ніч 20.00 до 5.59
    if (hour >= 20 || hour < 6) {
      return [
        const Color(0xFF1a0033),
        const Color(0xFF2d0052),
      ];
    }

    /// вечір-захід сонця - 18.00 до 19.59
    if (hour >= 18 && hour < 20) {
      return [
        const Color(0xFFFF8C42),
        const Color(0xFFFFB347),
      ];
    }

    /// світанок-ранок - 5.59 8.00
    if (hour >= 6 && hour < 8) {
      return [
        const Color(0xFFFF9E64),
        const Color(0xFF87CEEB),
      ];
    }

    /// день - з 8.00 до 17.59
    return [
      const Color(0xFF1E90FF),
      const Color(0xFF87CEEB),
    ];
  }

  /// перевірка дня
  static String getTimePeriod(DateTime dateTime, {int timezoneOffset = 0}) {
    final adjustedTime = dateTime.add(Duration(seconds: timezoneOffset));
    final hour = adjustedTime.hour;

    if (hour >= 20 || hour < 6) return 'night';
    if (hour >= 18 && hour < 20) return 'evening';
    if (hour >= 6 && hour < 8) return 'morning';
    return 'day';
  }

  /// чи захід сонця
  static bool isSunsetTime(DateTime dateTime, {int timezoneOffset = 0}) {
    final adjustedTime = dateTime.add(Duration(seconds: timezoneOffset));
    final hour = adjustedTime.hour;
    return hour >= 18 && hour < 20;
  }
}