import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  GetStorage _storage = GetStorage();
  String _key = "isDarkTheme";

  // false it mean light theme

  bool _loadTheme() {
    return _storage.read(_key) ?? false;
  }

  void _saveTheme(bool isDarkMode) {
    _storage.write(_key, isDarkMode);
  }

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadTheme() ? ThemeMode.light : ThemeMode.dark);
    _saveTheme(!_loadTheme());
  }
}
