import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PivotDataSource extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final List<String> permissions;

  const PivotDataSource({
    required this.id,
    required this.name,
    this.description = '',
    this.category = 'General',
    this.icon = Icons.table_chart,
    this.permissions = const [],
  });

  factory PivotDataSource.fromJson(Map<String, dynamic> json) => PivotDataSource(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? 'General',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
      };

  @override
  List<Object?> get props => [id, name, description, category, icon, permissions];
}
