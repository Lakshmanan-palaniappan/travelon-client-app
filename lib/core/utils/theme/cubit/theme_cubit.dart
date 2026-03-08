import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';


/// Manages the application's theme state using BLoC Cubit.
///
/// Responsible for:
/// - Loading the saved theme from local storage
/// - Updating and persisting the selected theme mode
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system)) {
    _loadTheme();
  }
  // SharedPreferences key used to store the selected theme mode
  static const _key = 'theme_mode';


  /// Loads the saved theme mode from SharedPreferences.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);

    switch (value) {
      case 'light':
        emit(const ThemeState(ThemeMode.light));
        break;
      case 'dark':
        emit(const ThemeState(ThemeMode.dark));
        break;
      default:
        emit(const ThemeState(ThemeMode.system));
    }
  }

  /// Updates the current theme and saves it to SharedPreferences.
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    if (mode == ThemeMode.light) {
      prefs.setString(_key, 'light');
    } else if (mode == ThemeMode.dark) {
      prefs.setString(_key, 'dark');
    } else {
      prefs.setString(_key, 'system');
    }

    emit(ThemeState(mode));
  }
}
