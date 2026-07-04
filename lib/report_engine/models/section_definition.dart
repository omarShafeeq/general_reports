import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

class SectionDefinition extends Equatable {
  final String id;
  final SectionType type;
  final int columns;
  final List<String> childIds;
  final bool collapsible;
  final String? title;
  final EdgeInsets? padding;
  final int columnSpan;
  final int order;
  final double? minHeight;
  final double? maxHeight;

  const SectionDefinition({
    required this.id,
    required this.type,
    this.columns = 1,
    this.childIds = const [],
    this.collapsible = false,
    this.title,
    this.padding,
    this.columnSpan = 1,
    this.order = 0,
    this.minHeight,
    this.maxHeight,
  });

  @override
  List<Object?> get props => [
        id, type, columns, childIds, collapsible, title, padding,
        columnSpan, order, minHeight, maxHeight,
      ];
}
