import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/chat_message.dart';

/// Pill showing active/completed tool execution status
class ToolStatusPill extends StatelessWidget {
  final ToolCallInfo toolCall;

  const ToolStatusPill({super.key, required this.toolCall});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isInvoking = toolCall.status == ToolExecutionStatus.invoking;
    final displayName = _formatToolName(toolCall.name);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isInvoking ? AppColors.accent.withAlpha(120) : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isInvoking) ...[
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 8),
          ] else ...[
            const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.success),
            const SizedBox(width: 6),
          ],
          Text(
            isInvoking ? 'Executing $displayName...' : '$displayName completed',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isInvoking ? AppColors.accent : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
          ),
        ],
      ),
    );
  }

  String _formatToolName(String rawName) {
    final clean = rawName.replaceAll('_', ' ');
    if (clean.isEmpty) return 'Travel Tool';
    return clean[0].toUpperCase() + clean.substring(1);
  }
}
