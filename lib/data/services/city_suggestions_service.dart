const List<String> _popularCities = [
  'London', 'Paris', 'Berlin', 'Madrid', 'Rome',
  'Amsterdam', 'Vienna', 'Prague', 'Warsaw', 'Budapest',
  'Athens', 'Lisbon', 'Dublin', 'Stockholm', 'Copenhagen',
  'Moscow', 'Istanbul', 'Barcelona', 'Milan', 'Geneva',
  'Zurich', 'Munich', 'Frankfurt', 'Brussels', 'Lyon',
  'Lviv', 'Kyiv', 'Kharkiv', 'Odesa', 'Dnipro',
  'New York', 'Los Angeles', 'Chicago', 'Toronto', 'Mexico City',
  'Tokyo', 'Beijing', 'Shanghai', 'Hong Kong', 'Singapore',
  'Sydney', 'Bangkok', 'Dubai', 'Mumbai', 'Delhi',
];

class CitySuggestionsService {
  static List<String> getSuggestions(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _popularCities
        .where((city) => city.toLowerCase().startsWith(lowerQuery))
        .toList();
  }
}