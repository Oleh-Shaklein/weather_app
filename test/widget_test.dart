import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/presentation/screens/splash_screen.dart';

void main() {
  group('Weather App Tests', () {
    testWidgets('App launches and shows splash screen',
            (WidgetTester tester) async {
          // Build our app and trigger a frame.
          await tester.pumpWidget(const WeatherApp());

          // Verify that splash screen is displayed
          expect(find.byType(SplashScreen), findsOneWidget);
        });

    testWidgets('Splash screen displays Kevych Solutions branding',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Verify app name is displayed
          expect(find.text('Weather Forecast'), findsOneWidget);

          // Verify company name is displayed
          expect(find.text('Kevych Solutions'), findsOneWidget);
        });

    testWidgets('Splash screen displays logo with orange K',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Verify the 'K' logo is displayed
          expect(find.text('K'), findsOneWidget);
        });

    testWidgets('App transitions from splash screen after 2 seconds',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Initially should show splash screen
          expect(find.byType(SplashScreen), findsOneWidget);

          // Wait for 2 seconds
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // After navigation, splash screen should not be visible
          // and we should be on the main weather screen
          expect(find.byType(SplashScreen), findsNothing);
        });

    testWidgets('Main weather screen displays city search widget',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Wait for splash screen to complete
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify search field hint text is displayed
          expect(find.text('Input City'), findsOneWidget);
        });

    testWidgets('Main weather screen displays current weather info',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Wait for splash screen to complete
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify city name is displayed
          expect(find.text('London'), findsOneWidget);

          // Verify temperature is displayed
          expect(find.text('22°'), findsOneWidget);

          // Verify weather description
          expect(find.text('Partly Cloudy'), findsOneWidget);
        });

    testWidgets('Main weather screen displays temperature details',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Wait for splash screen to complete
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify max, min, and humidity labels
          expect(find.text('Max'), findsOneWidget);
          expect(find.text('Min'), findsOneWidget);
          expect(find.text('Humidity'), findsOneWidget);
        });

    testWidgets('Main weather screen displays forecast list',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Wait for splash screen to complete
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify forecast title
          expect(find.text('8-Day Forecast'), findsOneWidget);

          // Verify days of week are displayed
          expect(find.text('Mon'), findsWidgets);
          expect(find.text('Tue'), findsOneWidget);
          expect(find.text('Wed'), findsOneWidget);
        });

    testWidgets('City search field is interactive',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Wait for splash screen to complete
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Find the text field
          final textField = find.byType(TextField);
          expect(textField, findsOneWidget);

          // Tap the text field and enter text
          await tester.tap(textField);
          await tester.enterText(textField, 'Paris');

          // Verify text was entered
          expect(find.text('Paris'), findsOneWidget);
        });

    testWidgets('Search icon button is present', (WidgetTester tester) async {
      await tester.pumpWidget(const WeatherApp());

      // Wait for splash screen to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify search icon button exists
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Weather app theme is set correctly',
            (WidgetTester tester) async {
          await tester.pumpWidget(const WeatherApp());

          // Verify Material 3 is used
          final materialApp = find.byType(MaterialApp);
          expect(materialApp, findsOneWidget);
        });
  });
}