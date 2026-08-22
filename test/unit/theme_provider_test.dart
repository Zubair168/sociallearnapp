import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sociallearnapp/core/theme/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial theme defaults to light mode', () async {
      final provider = ThemeProvider();
      expect(provider.themeMode, ThemeMode.light);
      expect(provider.isDarkMode, false);
    });

    test('toggleTheme updates state and saves to SharedPreferences', () async {
      final provider = ThemeProvider();
      
      await provider.toggleTheme(true);
      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.isDarkMode, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('theme_is_dark_mode'), true);

      await provider.toggleTheme(false);
      expect(provider.themeMode, ThemeMode.light);
      expect(provider.isDarkMode, false);
      expect(prefs.getBool('theme_is_dark_mode'), false);
    });
  });
}
