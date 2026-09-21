import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../auth/presentation/controllers/auth_bloc.dart';
import '../../../auth/presentation/controllers/auth_state.dart';
import '../../domain/entities/chat_session.dart';
import '../controllers/chat_bloc.dart';
import '../controllers/chat_event.dart';
import '../controllers/chat_state.dart';

/// Conversation History Drawer with on-demand session list fetching
class ChatHistoryDrawer extends StatefulWidget {
  const ChatHistoryDrawer({super.key});

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  @override
  void initState() {
    super.initState();
    // Fetch sessions lazily ONLY when drawer is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ChatBloc>().add(const ChatSessionsFetchRequested());
      }
    });
  }

  Future<void> _onRefresh() async {
    context.read<ChatBloc>().add(const ChatSessionsFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            _buildDrawerHeader(context, isDark),

            // "+ New Chat" CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text(
                  'New Conversation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.read<ChatBloc>().add(const ChatNewSessionRequested());
                  Navigator.of(context).pop(); // Close drawer
                },
              ),
            ),

            const Divider(height: 16),

            // Past Sessions List with Pull-to-Refresh
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state.isLoadingSessions && state.sessions.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (state.sessions.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppColors.primary,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 36,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No conversation history yet',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.primary,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      itemCount: state.sessions.length,
                      itemBuilder: (context, index) {
                        final session = state.sessions[index];
                        final isCurrent = session.id == state.sessionId;
                        return _buildSessionTile(context, session, isCurrent, isDark);
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom Clear All Button
            Padding(
              padding: const EdgeInsets.all(12),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                label: const Text(
                  'Clear History',
                  style: TextStyle(fontSize: 12, color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error.withAlpha(80)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _confirmClearHistory(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, bool isDark) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final profile = state is Authenticated ? state.userProfile : null;
        final userName = profile?.userName ?? 'User';
        final companyId = profile?.companyId ?? 'ACME';

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accentCyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Company: $companyId',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionTile(
    BuildContext context,
    ChatSessionSummary session,
    bool isCurrent,
    bool isDark,
  ) {
    final title = session.title.trim().isNotEmpty ? session.title : 'Conversation';
    final dateStr = session.updatedAt != null ? DateFormatter.formatTravelDate(session.updatedAt!) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isCurrent
            ? AppColors.primary.withAlpha(20)
            : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isCurrent
                ? AppColors.primary.withAlpha(120)
                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
            width: isCurrent ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          leading: Icon(
            Icons.chat_bubble_outline_rounded,
            size: 18,
            color: isCurrent ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              color: isCurrent ? AppColors.primary : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: dateStr.isNotEmpty
              ? Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                )
              : null,
          trailing: isCurrent
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            context.read<ChatBloc>().add(ChatSessionSelected(session.id));
            Navigator.of(context).pop(); // Close drawer
          },
        ),
      ),
    );
  }

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Conversations?'),
        content: const Text('This will delete your entire chat history on the server.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ChatBloc>().add(const ChatAllSessionsDeleteRequested());
              Navigator.of(context).pop(); // Close drawer
            },
            child: const Text('Delete All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
