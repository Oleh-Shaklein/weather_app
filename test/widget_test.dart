import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/presentation/screens/splash_screen.dart';

void main() {
  group('Weather App Tests', () {
    testWidgets('App launches and shows splash screen',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          expect(find.byType(SplashScreen), findsOneWidget);
        });

    testWidgets('Splash screen displays Kevych Solutions branding',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          expect(find.text('Weather Forecast'), findsOneWidget);
          expect(find.text('Kevych Solutions'), findsOneWidget);
        });

    testWidgets('Splash screen displays logo with orange K',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          expect(find.text('K'), findsOneWidget);
        });

    testWidgets('App transitions from splash screen after 2 seconds',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          expect(find.byType(SplashScreen), findsOneWidget);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.byType(SplashScreen), findsNothing);
        });

    testWidgets('Main weather screen displays city search widget',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.text('Input City'), findsOneWidget);
        });

    testWidgets('Main weather screen displays current weather info',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.text('London'), findsOneWidget);
          expect(find.text('22°'), findsOneWidget);
          expect(find.text('Partly Cloudy'), findsOneWidget);
        });

    testWidgets('Main weather screen displays temperature details',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.text('Max'), findsOneWidget);
          expect(find.text('Min'), findsOneWidget);
          expect(find.text('Humidity'), findsOneWidget);
        });

    testWidgets('Main weather screen displays forecast list',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.text('8-Day Forecast'), findsOneWidget);
          expect(find.text('Mon'), findsWidgets);
          expect(find.text('Tue'), findsOneWidget);
          expect(find.text('Wed'), findsOneWidget);
        });

    testWidgets('City search field is interactive',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          await tester.pumpAndSettle(const Duration(seconds: 2));
          final textField = find.byType(TextField);
          expect(textField, findsOneWidget);
          await tester.tap(textField);
          await tester.enterText(textField, 'Paris');
          expect(find.text('Paris'), findsOneWidget);
        });

    testWidgets('Search icon button is present', (WidgetTester tester) async {
      await tester.pumpWidget(const WeatherApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Weather app theme is set correctly',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());
          final materialApp = find.byType(MaterialApp);
          expect(materialApp, findsOneWidget);
        });
  });
}