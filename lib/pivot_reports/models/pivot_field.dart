import 'package:equatable/equatable.dart';

import 'enums.dart';

class PivotField extends Equatable {
  final String name;
  final String displayName;
  final PivotFieldType fieldType;
  final PivotFieldRole role;
  final PivotAggregation? aggregation;
  final PivotGroupInterval groupInterval;
  final PivotSortDirection sortDirection;

  const PivotField({
    required this.name,
    required this.displayName,
    required this.fieldType,
    this.role = PivotFieldRole.available,
    this.aggregation,
    this.groupInterval = PivotGroupInterval.none,
    this.sortDirection = PivotSortDirection.none,
  });

  PivotAggregation get effectiveAggregation =>
      aggregation ?? (fieldType.isNumeric ? PivotAggregation.sum : PivotAggregation.count);

  PivotField copyWith({
    String? name,
    String? displayName,
    PivotFieldType? fieldType,
    PivotFieldRole? role,
    PivotAggregation? aggregation,
    PivotGroupInterval? groupInterval,
    PivotSortDirection? sortDirection,
  }) {
    return PivotField(
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      fieldType: fieldType ?? this.fieldType,
      role: role ?? this.role,
      aggregation: aggregation ?? this.aggregation,
      groupInterval: groupInterval ?? this.groupInterval,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'displayName': displayName,
        'fieldType': fieldType.name,
        'role': role.name,
        'aggregation': aggregation?.name,
        'groupInterval': groupInterval.name,
        'sortDirection': sortDirection.name,
      };

  factory PivotField.fromJson(Map<String, dynamic> json) => PivotField(
        name: json['name'] as String,
        displayName: json['displayName'] as String,
        fieldType: PivotFieldType.values.byName(json['fieldType'] as String),
        role: PivotFieldRole.values.byName(json['role'] as String? ?? 'available'),
        aggregation: json['aggregation'] != null
            ? PivotAggregation.values.byName(json['aggregation'] as String)
            : null,
        groupInterval: json['groupInterval'] != null
            ? PivotGroupInterval.values.byName(json['groupInterval'] as String)
            : PivotGroupInterval.none,
        sortDirection: json['sortDirection'] != null
            ? PivotSortDirection.values.byName(json['sortDirection'] as String)
            : PivotSortDirection.none,
      );

  @override
  List<Object?> get props => [
        name, displayName, fieldType, role,
        aggregation, groupInterval, sortDirection,
      ];
}
