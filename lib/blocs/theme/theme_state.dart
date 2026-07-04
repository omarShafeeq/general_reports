import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isRtl;
  final Locale locale;

  const ThemeState({
    this.themeMode = ThemeMode.light,
    this.isRtl = false,
    this.locale = const Locale('en'),
  });

  bool get isDark => themeMode == ThemeMode.dark;

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isRtl,
    Locale? locale,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isRtl: isRtl ?? this.isRtl,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, isRtl, locale];
}
