import 'package:flutter/material.dart';
import '../services/db_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  final DbService dbService;

  ThemeController(this.dbService);

  ThemeMode get mode => _mode;

  void loadTheme() {
    final themeString = dbService.getThemeMode();
    _mode = {
      'system': ThemeMode.system,
      'light': ThemeMode.light,
      'dark': ThemeMode.dark,
    }[themeString]!;
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _mode = mode;
    await dbService.setThemeMode(mode.toString().split('.').last);
    notifyListeners();
  }
}