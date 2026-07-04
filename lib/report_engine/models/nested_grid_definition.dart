import 'package:equatable/equatable.dart';

import 'grid_definition.dart';

class NestedGridDefinition extends Equatable {
  final String id;
  final String parentKeyField;
  final String childDatasource;
  final String childFilterKey;
  final GridDefinition gridDefinition;
  final List<NestedGridDefinition> children;

  const NestedGridDefinition({
    required this.id,
    required this.parentKeyField,
    required this.childDatasource,
    required this.childFilterKey,
    required this.gridDefinition,
    this.children = const [],
  });

  @override
  List<Object?> get props => [
        id, parentKeyField, childDatasource, childFilterKey,
        gridDefinition, children,
      ];
}
