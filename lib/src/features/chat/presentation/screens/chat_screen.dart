import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/controllers/auth_bloc.dart';
import '../../../auth/presentation/controllers/auth_event.dart';
import '../../../auth/presentation/controllers/auth_state.dart';
import '../controllers/chat_bloc.dart';
import '../controllers/chat_event.dart';
import '../controllers/chat_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_history_drawer.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/travel_suggestion_bar.dart';

/// Real-time Agentic Travel Chat Screen with Session History
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _submitMessage(String text, {String agent = 'root'}) {
    context.read<ChatBloc>().add(
          ChatTurnSubmitted(
            message: text,
            agent: agent,
          ),
        );
    _scrollToBottom();
  }

  void _onArtifactSelected(Map<String, dynamic> item) {
    final title = item['flight_number'] ?? item['name'] ?? item['flight_id'] ?? 'this item';
    _submitMessage('Proceed with booking for $title');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      drawer: const ChatHistoryDrawer(),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.isStreaming || state.messages.isNotEmpty) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state.isLoadingHistory) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
                  SizedBox(height: 12),
                  Text('Loading conversation history...', style: TextStyle(fontSize: 13)),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Message Feed
              Expanded(
                child: state.messages.isEmpty
                    ? _buildWelcomeState(context, isDark)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final msg = state.messages[index];
                          return ChatBubble(
                            message: msg,
                            onArtifactItemSelected: _onArtifactSelected,
                          );
                        },
                      ),
              ),

              // Suggestion Pills
              TravelSuggestionBar(
                onSuggestionSelected: (prompt) => _submitMessage(prompt),
              ),

              // Input Bar
              ChatInputBar(
                isStreaming: state.isStreaming,
                onSend: (text) => _submitMessage(text),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      leading: Builder(
        builder: (ctx) => IconButton(
          tooltip: 'Conversation History',
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {
            context.read<ChatBloc>().add(const ChatSessionsFetchRequested());
            Scaffold.of(ctx).openDrawer();
          },
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.flight_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AIVA Travel Agent',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    final userName = authState is Authenticated
                        ? (authState.userProfile?.userName ?? 'Logged In')
                        : 'Active';
                    return BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, chatState) {
                        final sessionIndicator = chatState.sessionId != null
                            ? ' • Session active'
                            : ' • New Chat';
                        return Text(
                          '$userName$sessionIndicator',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'New Conversation',
          icon: const Icon(Icons.add_comment_outlined),
          onPressed: () {
            context.read<ChatBloc>().add(const ChatNewSessionRequested());
          },
        ),
        IconButton(
          tooltip: 'Sign Out',
          icon: const Icon(Icons.logout_rounded),
          onPressed: () {
            context.read<AuthBloc>().add(const AuthLogoutRequested());
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeState(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accentCyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(70),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 38),
          ),
          const SizedBox(height: 16),
          const Text(
            'Where would you like to travel?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Search real-time flights, compare hotel prices, check PNR status, and book your trip seamlessly.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          _buildFeatureCard(
            context,
            icon: Icons.flight_takeoff_rounded,
            color: AppColors.primary,
            title: 'Instant Flight Comparison',
            subtitle: 'Find cheapest fares, non-stop routes & baggage info.',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            context,
            icon: Icons.hotel_rounded,
            color: AppColors.accent,
            title: 'Curated Hotel Recommendations',
            subtitle: 'Find top rated hotels with amenities and instant booking.',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            context,
            icon: Icons.confirmation_number_outlined,
            color: AppColors.success,
            title: 'Live Booking & PNR Tracking',
            subtitle: 'Get instant E-Tickets, status alerts & itinerary summaries.',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
