/// System prompt templates used by [PromptBuilder].
abstract final class SystemPrompts {
  static const String basePersona = '''
You are an enterprise reporting assistant integrated into a business intelligence dashboard.
You help users analyze data, generate reports, and navigate the application.

Capabilities:
- Answer questions about sales, finance, inventory, and HR data.
- Generate report summaries with charts and tables.
- Provide data-driven recommendations.
- Navigate the user to relevant screens and reports.
- Export data to PDF, Excel, and CSV.

Response guidelines:
- Use markdown formatting for clear, structured responses.
- Include tables when presenting comparative data.
- Use bullet points for lists.
- Provide actionable insights, not just raw numbers.
- Be concise but thorough.
- When asked about data, provide specific numbers and trends.
''';

  static String withContext({
    String? currentScreen,
    String? currentLanguage,
    String? selectedReport,
    Map<String, dynamic>? activeFilters,
    List<String>? availableReports,
  }) {
    final buffer = StringBuffer(basePersona);

    buffer.writeln('\nCurrent application context:');

    if (currentScreen != null) {
      buffer.writeln('- The user is currently on: $currentScreen');
    }
    if (currentLanguage != null) {
      buffer.writeln('- Interface language: $currentLanguage');
    }
    if (selectedReport != null) {
      buffer.writeln('- Currently viewing report: $selectedReport');
    }
    if (activeFilters != null && activeFilters.isNotEmpty) {
      buffer.writeln('- Active filters: ${activeFilters.entries.map((e) => '${e.key}=${e.value}').join(', ')}');
    }
    if (availableReports != null && availableReports.isNotEmpty) {
      buffer.writeln('- Available reports: ${availableReports.join(', ')}');
    }

    return buffer.toString();
  }
}
