class LocalizationService {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'search_city': 'Search City',
      'input_city': 'Input City',
      'settings': 'Settings',
      'language': 'Language',
      'temperature_unit': 'Temperature Unit',
      'celsius': 'Celsius',
      'fahrenheit': 'Fahrenheit',
      'time_gradient': 'Time-based Background',
      'forecast': '6-Day Forecast',
      'max': 'Max',
      'min': 'Min',
      'humidity': 'Humidity',
      'wind': 'Wind',
      'pressure': 'Pressure',
      'feels_like': 'Feels like',
      'city_not_found': 'City not found',
      'retry': 'Retry',
      'error': 'Error',
      'clear': 'Clear',
      'cloudy': 'Cloudy',
      'partly_cloudy': 'Partly Cloudy',
      'wind_speed_unit': 'm/s',
      'humidity_icon': '💧',
    },
    'uk': {
      'search_city': 'Пошук міста',
      'input_city': 'Введіть місто',
      'settings': 'Налаштування',
      'language': 'Мова',
      'temperature_unit': 'Одиниця температури',
      'celsius': 'Цельсій',
      'fahrenheit': 'Фаренгейт',
      'time_gradient': 'Фон залежно від часу',
      'forecast': '6-денний прогноз',
      'max': 'Макс',
      'min': 'Мін',
      'humidity': 'Вологість',
      'wind': 'Вітер',
      'pressure': 'Тиск',
      'feels_like': 'Відчувається як',
      'city_not_found': 'Місто не знайдено',
      'retry': 'Повторити',
      'error': 'Помилка',
      'clear': 'Ясно',
      'cloudy': 'Хмарно',
      'partly_cloudy': 'Частково хмарно',
      'wind_speed_unit': 'м/с',
      'humidity_icon': '💧',
    },
  };
///зазвичай для цього використовував json для перебору, цьго разу попробував по іншому. ніби вийшло
  static String translate(String key, String language) {
    return _translations[language]?[key] ?? _translations['en']?[key] ?? key;
  }

  static List<String> getAvailableLanguages() => _translations.keys.toList();
}