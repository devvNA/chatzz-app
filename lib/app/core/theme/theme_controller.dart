import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static const String _storageKey = 'isDarkMode';
  final _storage = GetStorage();

  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() {
    final savedValue = _storage.read<bool>(_storageKey);
    _isDarkMode.value = savedValue ?? false;
    _updateSystemUI();
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _saveThemeToStorage();
    _updateTheme();
  }

  void setDarkMode(bool value) {
    if (_isDarkMode.value != value) {
      _isDarkMode.value = value;
      _saveThemeToStorage();
      _updateTheme();
    }
  }

  void _saveThemeToStorage() {
    _storage.write(_storageKey, _isDarkMode.value);
  }

  void _updateTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _updateSystemUI();
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      _isDarkMode.value
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFF1A1A2E),
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.white,
            ),
    );
  }
}
