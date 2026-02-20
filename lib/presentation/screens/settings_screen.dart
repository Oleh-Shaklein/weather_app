import 'package:flutter/material.dart';
import '../../data/services/localization_service.dart';

class SettingsScreen extends StatefulWidget {
  final String currentLanguage;
  final String currentTemperatureUnit;
  final bool timeGradientEnabled;
  final Function(String) onLanguageChanged;
  final Function(String) onTemperatureUnitChanged;
  final Function(bool) onTimeGradientChanged;

  const SettingsScreen({
    Key? key,
    required this.currentLanguage,
    required this.currentTemperatureUnit,
    required this.timeGradientEnabled,
    required this.onLanguageChanged,
    required this.onTemperatureUnitChanged,
    required this.onTimeGradientChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguage;
  late String _selectedTemperatureUnit;
  late bool _timeGradientEnabled;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
    _selectedTemperatureUnit = widget.currentTemperatureUnit;
    _timeGradientEnabled = widget.timeGradientEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocalizationService.translate('settings', _selectedLanguage),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[300]!],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Language Settings
            _buildSettingsCard(
              title: LocalizationService.translate('language', _selectedLanguage),
              child: Column(
                children: [
                  _buildLanguageOption('en', 'English'),
                  _buildLanguageOption('uk', 'Українська'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Temperature Unit Settings
            _buildSettingsCard(
              title: LocalizationService.translate(
                  'temperature_unit', _selectedLanguage),
              child: Column(
                children: [
                  _buildTemperatureOption('C',
                      LocalizationService.translate('celsius', _selectedLanguage)),
                  _buildTemperatureOption('F',
                      LocalizationService.translate('fahrenheit', _selectedLanguage)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Time Gradient Settings
            _buildSettingsCard(
              title: LocalizationService.translate('time_gradient', _selectedLanguage),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      LocalizationService.translate(
                          'time_gradient', _selectedLanguage),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Switch(
                    value: _timeGradientEnabled,
                    onChanged: (value) {
                      setState(() {
                        _timeGradientEnabled = value;
                      });
                      widget.onTimeGradientChanged(value);
                    },
                    activeColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name) {
    return RadioListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      value: code,
      groupValue: _selectedLanguage,
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value!;
        });
        widget.onLanguageChanged(value!);
      },
      fillColor: MaterialStateColor.resolveWith(
            (states) => Colors.white,
      ),
    );
  }

  Widget _buildTemperatureOption(String unit, String name) {
    return RadioListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      value: unit,
      groupValue: _selectedTemperatureUnit,
      onChanged: (value) {
        setState(() {
          _selectedTemperatureUnit = value!;
        });
        widget.onTemperatureUnitChanged(value!);
      },
      fillColor: MaterialStateColor.resolveWith(
            (states) => Colors.white,
      ),
    );
  }
}