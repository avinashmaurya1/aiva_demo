import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Quick travel prompt suggestions bar
class TravelSuggestionBar extends StatelessWidget {
  final ValueChanged<String> onSuggestionSelected;

  const TravelSuggestionBar({
    super.key,
    required this.onSuggestionSelected,
  });

  static const List<(String, String)> _suggestions = [
    ('✈️ Flights DEL → BOM', 'Find morning flights from Delhi to Mumbai tomorrow'),
    ('🏨 Hotels in Goa', 'Search 4-star and 5-star hotels in Goa under ₹6000'),
    ('✈️ Cheap Flights to BLR', 'Find cheapest non-stop flights to Bangalore this weekend'),
    ('🎫 My Bookings', 'Show my recent travel bookings and tickets'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _suggestions.map((item) {
          final (label, prompt) = item;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              side: BorderSide(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () => onSuggestionSelected(prompt),
            ),
          );
        }).toList(),
      ),
    );
  }
}
