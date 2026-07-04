import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_reports/blocs/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void toggleTheme() {
    emit(state.copyWith(
      themeMode: state.isDark ? ThemeMode.light : ThemeMode.dark,
    ));
  }

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void toggleRtl() {
    final newRtl = !state.isRtl;
    emit(state.copyWith(
      isRtl: newRtl,
      locale: newRtl ? const Locale('ar') : const Locale('en'),
    ));
  }
}
