import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  MediaQueryData get mq => MediaQuery.of(this);
  double get screenWidth => mq.size.width;
  double get screenHeight => mq.size.height;

  bool get isMobile => screenWidth < AppSizes.mobileBreakpoint;
  bool get isTablet =>
      screenWidth >= AppSizes.mobileBreakpoint &&
      screenWidth < AppSizes.tabletBreakpoint;
  bool get isDesktop => screenWidth >= AppSizes.tabletBreakpoint;

  bool get isDarkMode => theme.brightness == Brightness.dark;
}
