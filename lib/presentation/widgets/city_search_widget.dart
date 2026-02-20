import 'package:flutter/material.dart';
import '../../data/services/city_suggestions_service.dart';

class CitySearchWidget extends StatefulWidget {
  final Function(String) onCityChanged;

  const CitySearchWidget({
    Key? key,
    required this.onCityChanged,
  }) : super(key: key);

  @override
  State<CitySearchWidget> createState() => _CitySearchWidgetState();
}

class _CitySearchWidgetState extends State<CitySearchWidget> {
  late TextEditingController _controller;
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch() {
    if (_controller.text.isNotEmpty) {
      widget.onCityChanged(_controller.text);
      _controller.clear();
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
    }
  }

  void _updateSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _suggestions = [];
        _showSuggestions = false;
      } else {
        _suggestions = CitySuggestionsService.getSuggestions(query);
        _showSuggestions = _suggestions.isNotEmpty;
      }
    });
  }

  void _selectSuggestion(String city) {
    _controller.text = city;
    widget.onCityChanged(city);
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: _controller,
          onChanged: _updateSuggestions,
          onSubmitted: (_) => _handleSearch(),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Input City',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: _handleSearch,
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        if (_showSuggestions)
          Positioned(
            top: 56,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _suggestions[index],
                      style: const TextStyle(color: Colors.black87),
                    ),
                    onTap: () => _selectSuggestion(_suggestions[index]),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}