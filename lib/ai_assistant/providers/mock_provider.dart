import 'dart:math';

import '../models/ai_message.dart';
import '../models/ai_response.dart';
import '../models/function_call.dart';
import '../models/token_usage.dart';
import 'ai_provider.dart';

/// Deterministic mock AI provider for development and testing.
///
/// Returns canned enterprise-style responses with realistic delays so the UI
/// can be developed without a live backend.
class MockProvider implements AIProvider {
  final _random = Random(42);

  @override
  String get displayName => 'Mock AI';

  @override
  Future<AIResponse> generateResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  }) async {
    await Future.delayed(Duration(milliseconds: 600 + _random.nextInt(800)));

    final lastMessage =
        messages.lastWhere((m) => m.role == MessageRole.user).content.toLowerCase();

    final response = _pickResponse(lastMessage);

    return AIResponse(
      text: response,
      tokenUsage: TokenUsage(
        promptTokens: lastMessage.length,
        completionTokens: response.length,
        totalTokens: lastMessage.length + response.length,
      ),
      suggestions: _suggestionsFor(lastMessage),
    );
  }

  @override
  Stream<String> streamResponse({
    required List<AIMessage> messages,
    required String systemPrompt,
    List<FunctionDefinition>? functions,
  }) async* {
    final lastMessage =
        messages.lastWhere((m) => m.role == MessageRole.user).content.toLowerCase();
    final response = _pickResponse(lastMessage);
    final words = response.split(' ');

    for (var i = 0; i < words.length; i++) {
      await Future.delayed(Duration(milliseconds: 30 + _random.nextInt(60)));
      yield '${words[i]}${i < words.length - 1 ? ' ' : ''}';
    }
  }

  String _pickResponse(String query) {
    if (query.contains('sales') || query.contains('revenue')) {
      return '## Sales Overview\n\n'
          'Based on the current data, here are the key highlights:\n\n'
          '- **Total Revenue**: \$1,247,850 (+12.5% YoY)\n'
          '- **Total Orders**: 1,000 (+8.3% YoY)\n'
          '- **Avg Order Value**: \$1,248 (+4.1% YoY)\n\n'
          'The **North America** region leads with \$280,000 in revenue, '
          'followed by **Europe** at \$245,000.\n\n'
          '### Recommendation\n'
          'Focus marketing efforts on the **Asia Pacific** region which '
          'shows 22% growth potential based on current trends.';
    }

    if (query.contains('customer') || query.contains('top')) {
      return '## Top Customers\n\n'
          '| Rank | Customer | Revenue | Orders |\n'
          '|------|----------|---------|--------|\n'
          '| 1 | Acme Corp | \$125,400 | 45 |\n'
          '| 2 | GlobalTech | \$98,200 | 38 |\n'
          '| 3 | Summit Industries | \$87,600 | 32 |\n'
          '| 4 | Vertex Solutions | \$76,300 | 28 |\n'
          '| 5 | Pinnacle Group | \$65,100 | 24 |\n\n'
          'Acme Corp remains the highest-value customer with a **28%** '
          'increase in order volume this quarter.';
    }

    if (query.contains('inventory') || query.contains('stock')) {
      return '## Inventory Status\n\n'
          '- **Total Items**: 12,450 units across 6 categories\n'
          '- **Low Stock Alerts**: 8 products below reorder level\n'
          '- **Total Inventory Value**: \$2,340,500\n\n'
          '### Low Stock Items\n'
          '1. Wireless Mouse (SKU-1023) — 5 remaining\n'
          '2. USB-C Hub (SKU-1045) — 12 remaining\n'
          '3. Monitor 4K (SKU-1067) — 3 remaining\n\n'
          'Consider placing restock orders for these items immediately.';
    }

    if (query.contains('compare') || query.contains('year')) {
      return '## Year-over-Year Comparison\n\n'
          '| Metric | This Year | Last Year | Change |\n'
          '|--------|-----------|-----------|--------|\n'
          '| Revenue | \$1,247,850 | \$1,109,200 | +12.5% |\n'
          '| Orders | 1,000 | 923 | +8.3% |\n'
          '| Avg Order | \$1,248 | \$1,202 | +3.8% |\n'
          '| Customers | 285 | 264 | +7.9% |\n\n'
          'All key metrics show positive growth, with revenue '
          'leading at **12.5%** improvement.';
    }

    if (query.contains('finance') || query.contains('profit') || query.contains('expense')) {
      return '## Financial Summary\n\n'
          '- **Net Profit**: \$186,450 (+15.2% YoY)\n'
          '- **Total Expenses**: \$892,300 (-3.1% YoY)\n'
          '- **Profit Margin**: 17.3% (+2.4pp)\n\n'
          '### Expense Breakdown\n'
          '- Salaries: 42%\n'
          '- Marketing: 18%\n'
          '- R&D: 15%\n'
          '- Operations: 12%\n'
          '- Infrastructure: 8%\n'
          '- Legal: 5%\n\n'
          'Operating cash flow has improved by **7.8%** indicating '
          'healthy financial operations.';
    }

    if (query.contains('help') || query.contains('what can')) {
      return '## How I Can Help\n\n'
          'I\'m your enterprise reporting assistant. Here\'s what I can do:\n\n'
          '- **Generate Reports**: "Show monthly sales", "Top 10 customers"\n'
          '- **Analyze Data**: "Compare revenue YoY", "Best selling products"\n'
          '- **Inventory**: "Show low stock items", "Inventory value by category"\n'
          '- **Finance**: "Show profit margins", "Expense breakdown"\n'
          '- **Navigate**: "Go to sales dashboard", "Open report catalog"\n'
          '- **Export**: "Export sales data to PDF"\n\n'
          'Just ask me anything about your business data!';
    }

    return '## Response\n\n'
        'I can help you with reports, data analysis, inventory management, '
        'and financial insights.\n\n'
        'Try asking me:\n'
        '- "Show monthly sales overview"\n'
        '- "Top 10 customers by revenue"\n'
        '- "Inventory below minimum stock"\n'
        '- "Compare this year vs last year"\n\n'
        'What would you like to know?';
  }

  List<String> _suggestionsFor(String query) {
    if (query.contains('sales')) {
      return ['Show top customers', 'Compare with last year', 'Export to PDF'];
    }
    if (query.contains('inventory')) {
      return ['Show low stock items', 'Inventory by category', 'Reorder suggestions'];
    }
    if (query.contains('finance')) {
      return ['Show expense breakdown', 'Quarterly comparison', 'Cash flow analysis'];
    }
    return ['Show sales overview', 'Top customers', 'Inventory status'];
  }
}
