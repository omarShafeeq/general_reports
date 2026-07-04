import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveUtils {
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < AppSizes.mobileBreakpoint) return DeviceType.mobile;
    if (width < AppSizes.tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static int gridCrossAxisCount(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return 1;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
        return 3;
    }
  }

  static int kpiCrossAxisCount(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return 2;
      case DeviceType.tablet:
        return 3;
      case DeviceType.desktop:
        return 4;
    }
  }

  static double chartHeight(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return 300;
      case DeviceType.tablet:
        return 400;
      case DeviceType.desktop:
        return 450;
    }
  }
}
