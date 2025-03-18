import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _useDynamicTheme = true;
  String _username = 'Samuel';

  ThemeMode get themeMode => _themeMode;
  bool get useDynamicTheme => _useDynamicTheme;
  String get username => _username;

  SettingsProvider() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme mode
      final themeModeIndex = prefs.getInt('theme_mode');
      if (themeModeIndex != null) {
        _themeMode = ThemeMode.values[themeModeIndex];
      }

      // Load dynamic theme preference
      final useDynamicTheme = prefs.getBool('use_dynamic_theme');
      if (useDynamicTheme != null) {
        _useDynamicTheme = useDynamicTheme;
      }

      // Load username
      final username = prefs.getString('username');
      if (username != null && username.isNotEmpty) {
        _username = username;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('theme_mode', _themeMode.index);
      await prefs.setBool('use_dynamic_theme', _useDynamicTheme);
      await prefs.setString('username', _username);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    _saveSettings();
  }

  void toggleDynamicTheme(bool value) {
    _useDynamicTheme = value;
    notifyListeners();
    _saveSettings();
  }

  void setUsername(String name) {
    _username = name;
    notifyListeners();
    _saveSettings();
  }
}