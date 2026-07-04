import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_colors.dart';

abstract final class AppColorSchemes {
  static ColorScheme light = ColorScheme.fromSeed(
    seedColor: AppColors.seedColor,
    brightness: Brightness.light,
  );

  static ColorScheme dark = ColorScheme.fromSeed(
    seedColor: AppColors.seedColor,
    brightness: Brightness.dark,
  );
}
