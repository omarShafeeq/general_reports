import 'package:equatable/equatable.dart';

class FunctionCall extends Equatable {
  final String name;
  final Map<String, dynamic> arguments;
  final dynamic result;
  final bool isExecuted;

  const FunctionCall({
    required this.name,
    required this.arguments,
    this.result,
    this.isExecuted = false,
  });

  FunctionCall withResult(dynamic result) => FunctionCall(
        name: name,
        arguments: arguments,
        result: result,
        isExecuted: true,
      );

  @override
  List<Object?> get props => [name, arguments, result, isExecuted];
}

class FunctionDefinition extends Equatable {
  final String name;
  final String description;
  final Map<String, FunctionParam> parameters;

  const FunctionDefinition({
    required this.name,
    required this.description,
    this.parameters = const {},
  });

  Map<String, dynamic> toToolSchema() => {
        'type': 'function',
        'function': {
          'name': name,
          'description': description,
          'parameters': {
            'type': 'object',
            'properties': parameters.map(
              (k, v) => MapEntry(k, v.toSchema()),
            ),
            'required':
                parameters.entries.where((e) => e.value.required).map((e) => e.key).toList(),
          },
        },
      };

  @override
  List<Object?> get props => [name, description, parameters];
}

class FunctionParam extends Equatable {
  final String type;
  final String description;
  final bool required;
  final List<String>? enumValues;

  const FunctionParam({
    required this.type,
    required this.description,
    this.required = false,
    this.enumValues,
  });

  Map<String, dynamic> toSchema() => {
        'type': type,
        'description': description,
        if (enumValues != null) 'enum': enumValues,
      };

  @override
  List<Object?> get props => [type, description, required, enumValues];
}
