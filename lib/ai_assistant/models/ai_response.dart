import 'package:equatable/equatable.dart';

import '../../report_engine/models/report_definition.dart';
import 'function_call.dart';
import 'token_usage.dart';

class AIResponse extends Equatable {
  final String text;
  final ReportDefinition? reportDefinition;
  final List<FunctionCall> functionCalls;
  final TokenUsage? tokenUsage;
  final List<String> suggestions;
  final Map<String, dynamic> metadata;

  const AIResponse({
    required this.text,
    this.reportDefinition,
    this.functionCalls = const [],
    this.tokenUsage,
    this.suggestions = const [],
    this.metadata = const {},
  });

  bool get hasReport => reportDefinition != null;
  bool get hasFunctionCalls => functionCalls.isNotEmpty;
  bool get hasSuggestions => suggestions.isNotEmpty;

  @override
  List<Object?> get props => [
        text,
        reportDefinition,
        functionCalls,
        tokenUsage,
        suggestions,
        metadata,
      ];
}
