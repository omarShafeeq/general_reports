import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_sizes.dart';
import '../../report_engine/data/mock_report_repository.dart';
import '../../widgets/common/responsive_scaffold.dart';
import '../../routing/route_names.dart';
import '../blocs/ai_chat_cubit.dart';
import '../blocs/ai_chat_state.dart';
import '../blocs/conversation_list_cubit.dart';
import '../models/function_call.dart';
import '../providers/mock_provider.dart';
import '../repositories/ai_repository.dart';
import '../repositories/conversation_repository.dart';
import '../services/app_context_service.dart';
import '../services/function_registry.dart';
import '../services/prompt_builder.dart';
import '../services/report_detector.dart';
import '../widgets/ai_chat_view.dart';
import '../widgets/conversation_sidebar.dart';

/// Full-page AI assistant with conversation sidebar and chat view.
class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  late final ConversationRepository _conversationRepo;
  late final AIRepository _aiRepository;
  late final AIChatCubit _chatCubit;
  late final ConversationListCubit _listCubit;
  bool _sidebarOpen = true;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _conversationRepo = ConversationRepository();
    _listCubit = ConversationListCubit(repository: _conversationRepo);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final contextService = AppContextService(context);
    final promptBuilder = PromptBuilder(contextService: contextService);
    final functionRegistry = _buildFunctionRegistry();

    _aiRepository = AIRepository(
      provider: MockProvider(),
      promptBuilder: promptBuilder,
      functionRegistry: functionRegistry,
    );

    _chatCubit = AIChatCubit(
      aiRepository: _aiRepository,
      conversationRepository: _conversationRepo,
      reportDetector: ReportDetector(),
      functionRegistry: functionRegistry,
    );
  }

  FunctionRegistry _buildFunctionRegistry() {
    final reportRepo = MockReportRepository();
    final registry = FunctionRegistry();

    registry.register(
      name: 'getSales',
      description: 'Fetch sales overview data including revenue, orders, and trends.',
      handler: (args) => reportRepo.fetchReportData('sales-overview', args),
      parameters: {
        'year': const FunctionParam(
          type: 'integer',
          description: 'Filter by year',
        ),
      },
    );

    registry.register(
      name: 'getCustomers',
      description: 'Fetch customer sales data.',
      handler: (args) => reportRepo.fetchReportData('sales-by-customer', args),
    );

    registry.register(
      name: 'getInventory',
      description: 'Fetch inventory status including stock levels.',
      handler: (args) => reportRepo.fetchReportData('inventory-status', args),
    );

    registry.register(
      name: 'getFinanceSummary',
      description: 'Fetch financial summary with P&L and expenses.',
      handler: (args) => reportRepo.fetchReportData('finance-summary', args),
    );

    registry.register(
      name: 'getInvoices',
      description: 'Fetch invoice/transaction data from the finance module.',
      handler: (args) => reportRepo.fetchReportData('finance-summary', args),
    );

    registry.register(
      name: 'getDashboard',
      description: 'Fetch dashboard overview data.',
      handler: (args) => reportRepo.fetchReportData('sales-overview', args),
    );

    return registry;
  }

  @override
  void dispose() {
    _chatCubit.close();
    _listCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.sizeOf(context).width >= AppSizes.tabletBreakpoint;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _chatCubit),
        BlocProvider.value(value: _listCubit),
      ],
      child: ResponsiveScaffold(
        title: 'AI Assistant',
        currentRoute: RouteNames.aiAssistant,
        actions: [
          BlocBuilder<AIChatCubit, AIChatState>(
            bloc: _chatCubit,
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isDesktop)
                    IconButton(
                      icon: Icon(
                        _sidebarOpen
                            ? Icons.view_sidebar
                            : Icons.menu_open,
                      ),
                      tooltip: _sidebarOpen
                          ? 'Hide conversations'
                          : 'Show conversations',
                      onPressed: () =>
                          setState(() => _sidebarOpen = !_sidebarOpen),
                    ),
                  IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    tooltip: 'New conversation',
                    onPressed: () {
                      _chatCubit.newConversation();
                      _listCubit.refresh();
                    },
                  ),
                  if (state.messages.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Clear chat',
                      onPressed: () => _chatCubit.clearChat(),
                    ),
                ],
              );
            },
          ),
        ],
        body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        if (_sidebarOpen)
          SizedBox(
            width: 300,
            child: ConversationSidebar(
              onConversationSelected: (id) {
                _chatCubit.loadConversation(id);
              },
            ),
          ),
        if (_sidebarOpen)
          const VerticalDivider(width: 1, thickness: 1),
        const Expanded(child: AIChatView()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return const AIChatView();
  }
}
