import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'drill_down_definition.dart';

class CardDefinition extends Equatable {
  final String id;
  final String title;
  final String dataKey;
  final String? trendKey;
  final IconData icon;
  final Color? color;
  final String? formatString;
  final bool isCurrency;
  final DrillDownDefinition? drillDown;

  const CardDefinition({
    required this.id,
    required this.title,
    required this.dataKey,
    this.trendKey,
    this.icon = Icons.trending_up,
    this.color,
    this.formatString,
    this.isCurrency = false,
    this.drillDown,
  });

  @override
  List<Object?> get props => [
        id, title, dataKey, trendKey, icon, color,
        formatString, isCurrency, drillDown,
      ];
}
