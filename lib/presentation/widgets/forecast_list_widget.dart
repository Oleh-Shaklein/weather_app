import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import '../../data/services/localization_service.dart';
import 'forecast_card_widget.dart';

class ForecastListWidget extends StatelessWidget {
  final List<ForecastDay> forecast;
  final String temperatureUnit;
  final String language;

  const ForecastListWidget({
    Key? key,
    required this.forecast,
    this.temperatureUnit = 'C',
    this.language = 'en',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            LocalizationService.translate('forecast', language),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: forecast.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final previousDay = index > 0 ? forecast[index - 1] : null;
              return ForecastCardWidget(
                day: forecast[index],
                previousDay: previousDay,
                temperatureUnit: temperatureUnit,
                language: language,
              );
            },
          ),
        ),
      ],
    );
  }
}