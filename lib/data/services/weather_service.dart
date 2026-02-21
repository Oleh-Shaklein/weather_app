import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = '9e7b4ee3bb69c21547975d5d859a6395';

  Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      final url = Uri.parse(
        '$baseUrl/weather?q=$city&appid=$apiKey&units=metric',
      );

      print('Requesting URL: $url');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Check your OpenWeatherMap API key.');
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<WeatherModel> getWeatherByCoordinates(
      double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        '$baseUrl/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Check your OpenWeatherMap API key.');
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get 8+ day forecast
  Future<List<ForecastDay>> getForecast(String city) async {
    try {
      final url = Uri.parse(
        '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric&cnt=40',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> forecastList = data['list'] ?? [];

        // Group forecasts by day and take one per day (preferably noon)
        Map<String, ForecastDay> dailyForecasts = {};

        for (var item in forecastList) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(
            item['dt'] * 1000,
          );
          final dayKey = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

          // Prefer noon (12:00) forecasts
          if (!dailyForecasts.containsKey(dayKey) || dateTime.hour == 12) {
            dailyForecasts[dayKey] = ForecastDay(
              dayOfWeek: _getDayOfWeek(item['dt']),
              weatherIcon: item['weather'][0]['icon'],
              temperature: (item['main']['temp']).toDouble(),
              maxTemp: (item['main']['temp_max'] ?? item['main']['temp']).toDouble(),
              minTemp: (item['main']['temp_min'] ?? item['main']['temp']).toDouble(),
              humidity: item['main']['humidity'],
              windSpeed: (item['wind']['speed'] ?? 0).toDouble(),
              cloudiness: item['clouds']['all'] ?? 0,
              rainProbability: ((item['pop'] ?? 0) * 100).toInt(),
            );
          }
        }

        // Return up to 8 days
        return dailyForecasts.values.toList().take(8).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Check your OpenWeatherMap API key.');
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get current device location
  Future<Position> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are denied forever. Enable in settings.');
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      rethrow;
    }
  }

  /// Format day of week from timestamp
  String _getDayOfWeek(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dateTime.weekday - 1];
  }
}