import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';

/// E-Ticket & Booking confirmation card
class BookingCard extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingCard({
    super.key,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bookingId = bookingData['booking_id']?.toString() ??
        bookingData['pnr']?.toString() ??
        'AIVA-8821';
    final type = bookingData['type']?.toString() ?? 'Flight';
    final status = bookingData['status']?.toString() ?? 'CONFIRMED';
    final route = bookingData['route']?.toString() ?? 'DEL → BOM';
    final date = bookingData['date']?.toString() ?? 'Mon, 10 Aug';
    final passenger = bookingData['passenger']?.toString() ?? 'Lead Passenger';
    final rawAmount = bookingData['amount'] ?? bookingData['total'] ?? 5499;
    final amount = rawAmount is num ? rawAmount : 5499;

    final isConfirmed = status.toUpperCase().contains('CONFIRM');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isConfirmed ? AppColors.success.withAlpha(120) : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      type.toLowerCase().contains('hotel') ? Icons.hotel_rounded : Icons.confirmation_number_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Booking #$bookingId',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (isConfirmed ? AppColors.success : AppColors.warning).withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isConfirmed ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Route',
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      route,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Passenger: $passenger',
                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
                Text(
                  CurrencyFormatter.formatInr(amount),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
