import '../config/system_prompts.dart';
import '../models/function_call.dart';
import 'app_context_service.dart';

/// Constructs the system prompt by combining the base persona, current
/// application context, and (optionally) available function schemas.
class PromptBuilder {
  final AppContextService _contextService;

  const PromptBuilder({required AppContextService contextService})
      : _contextService = contextService;

  String build({List<FunctionDefinition>? functions}) {
    final ctx = _contextService.currentContext;

    final prompt = SystemPrompts.withContext(
      currentScreen: ctx['currentScreen'] as String?,
      currentLanguage: ctx['language'] as String?,
      selectedReport: ctx['selectedReport'] as String?,
      activeFilters: ctx['activeFilters'] as Map<String, dynamic>?,
      availableReports: (ctx['availableReports'] as List<dynamic>?)
          ?.cast<String>(),
    );

    if (functions == null || functions.isEmpty) return prompt;

    final buffer = StringBuffer(prompt)
      ..writeln('\nAvailable functions you can call:');
    for (final fn in functions) {
      buffer.writeln('- ${fn.name}: ${fn.description}');
    }
    return buffer.toString();
  }
}
