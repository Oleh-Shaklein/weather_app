import 'package:flutter/material.dart';

class WeatherTimeHelper {
  /// Get background gradient colors based on time of day and timezone offset
  static List<Color> getGradientColorsByTime(
      DateTime dateTime, {
        int timezoneOffset = 0,
      }) {
    // Adjust time by timezone offset
    final adjustedTime = dateTime.add(Duration(seconds: timezoneOffset));
    final hour = adjustedTime.hour;

    // Night: 20:00 - 5:59 (dark purple gradient)
    if (hour >= 20 || hour < 6) {
      return [
        const Color(0xFF1a0033), // Dark purple
        const Color(0xFF2d0052),
      ];
    }

    // Evening/Sunset: 18:00 - 19:59 (orange gradient)
    if (hour >= 18 && hour < 20) {
      return [
        const Color(0xFFFF8C42), // Light orange
        const Color(0xFFFFB347),
      ];
    }

    // Morning: 5:59 - 8:00 (soft orange to blue)
    if (hour >= 6 && hour < 8) {
      return [
        const Color(0xFFFF9E64), // Soft orange
        const Color(0xFF87CEEB), // Sky blue
      ];
    }

    // Day: 8:00 - 17:59 (blue gradient)
    return [
      const Color(0xFF1E90FF), // Dodger blue
      const Color(0xFF87CEEB), // Sky blue
    ];
  }

  /// Get time period string
  static String getTimePeriod(DateTime dateTime, {int timezoneOffset = 0}) {
    final adjustedTime = dateTime.add(Duration(seconds: timezoneOffset));
    final hour = adjustedTime.hour;

    if (hour >= 20 || hour < 6) return 'night';
    if (hour >= 18 && hour < 20) return 'evening';
    if (hour >= 6 && hour < 8) return 'morning';
    return 'day';
  }

  /// Check if it's sunset time (+-1 hour)
  static bool isSunsetTime(DateTime dateTime, {int timezoneOffset = 0}) {
    final adjustedTime = dateTime.add(Duration(seconds: timezoneOffset));
    final hour = adjustedTime.hour;
    return hour >= 18 && hour < 20;
  }
}