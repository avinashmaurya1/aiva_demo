import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Bottom Chat Input Bar with auto-expanding text field and send trigger
class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isStreaming;

  const ChatInputBar({
    super.key,
    required this.onSend,
    this.isStreaming = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasNow = _controller.text.trim().isNotEmpty;
      if (hasNow != _hasText) {
        setState(() => _hasText = hasNow);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isStreaming) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: const TextStyle(fontSize: 14.5),
                  decoration: const InputDecoration(
                    hintText: 'Ask AIVA: e.g. "Find flights DEL to BOM"',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: (_hasText && !widget.isStreaming)
                    ? AppColors.primary
                    : (isDark ? AppColors.cardDark : AppColors.cardBorderLight),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: widget.isStreaming
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        Icons.arrow_upward_rounded,
                        color: _hasText ? Colors.white : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                        size: 22,
                      ),
                onPressed: (_hasText && !widget.isStreaming) ? _handleSend : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
