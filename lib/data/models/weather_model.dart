class WeatherModel {
  final String city;
  final double temperature;
  final double maxTemp;
  final double minTemp;
  final int humidity;
  final String description;
  final String weatherIcon;
  final double feelsLike;
  final double windSpeed;
  final int pressure;
  final int timezoneOffset; // Add this

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.humidity,
    required this.description,
    required this.weatherIcon,
    required this.feelsLike,
    required this.windSpeed,
    required this.pressure,
    this.timezoneOffset = 0,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      maxTemp: (json['main']['temp_max'] ?? 0).toDouble(),
      minTemp: (json['main']['temp_min'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      description: json['weather'][0]['main'] ?? 'Unknown',
      weatherIcon: json['weather'][0]['icon'] ?? '01d',
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      timezoneOffset: json['timezone'] ?? 0, // Get timezone from API
    );
  }
}

class ForecastDay {
  final String dayOfWeek;
  final String weatherIcon;
  final double temperature;
  final double maxTemp;
  final double minTemp;
  final int humidity;
  final String? description;
  final double windSpeed;
  final int cloudiness;
  final int rainProbability;

  ForecastDay({
    required this.dayOfWeek,
    required this.weatherIcon,
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.humidity,
    this.description,
    this.windSpeed = 0,
    this.cloudiness = 0,
    this.rainProbability = 0,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      dayOfWeek: json['day'] ?? 'Day',
      weatherIcon: json['icon'] ?? '01d',
      temperature: (json['temp'] ?? 0).toDouble(),
      maxTemp: (json['main_temp_max'] ?? json['temp'] ?? 0).toDouble(),
      minTemp: (json['main_temp_min'] ?? json['temp'] ?? 0).toDouble(),
      humidity: json['humidity'] ?? 0,
      description: json['description'] ?? 'Unknown',
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      cloudiness: json['clouds'] ?? 0,
      rainProbability: json['pop'] ?? 0,
    );
  }

  /// Compare temperature with another day
  int getTemperatureChange(ForecastDay? previousDay) {
    if (previousDay == null) return 0;
    return (temperature - previousDay.temperature).toInt();
  }

  /// Get weather description with probability - SIMPLIFIED (no rain indicator)
  String getWeatherDescriptionWithProbability() {
    if (cloudiness > 70) {
      return 'Cloudy';
    }
    if (cloudiness > 40) {
      return 'Partly Cloudy';
    }
    return 'Clear';
  }
}