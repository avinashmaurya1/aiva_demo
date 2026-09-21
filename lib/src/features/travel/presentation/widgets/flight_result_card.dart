import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Ixigo-inspired Flight Search Result Card
class FlightResultCard extends StatelessWidget {
  final Map<String, dynamic> flightData;
  final VoidCallback? onBookPressed;

  const FlightResultCard({
    super.key,
    required this.flightData,
    this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final airline = flightData['airline']?.toString() ??
        flightData['airline_name']?.toString() ??
        flightData['carrier']?.toString() ??
        'Flight';
    final flightNumber = flightData['flight_number']?.toString() ??
        flightData['flightNo']?.toString() ??
        flightData['flight_id']?.toString() ??
        '6E-204';
    final origin = flightData['origin']?.toString() ??
        flightData['departure_airport']?.toString() ??
        'DEL';
    final destination = flightData['destination']?.toString() ??
        flightData['arrival_airport']?.toString() ??
        'BOM';
    final depTime = flightData['departure_time']?.toString() ??
        flightData['depTime']?.toString() ??
        '06:00 AM';
    final arrTime = flightData['arrival_time']?.toString() ??
        flightData['arrTime']?.toString() ??
        '08:15 AM';
    final duration = flightData['duration']?.toString() ?? '2h 15m';
    final stops = flightData['stops']?.toString() ?? 'Non-stop';
    final rawPrice = flightData['price'] ?? flightData['fare'] ?? flightData['cheapest'] ?? 4599;
    final price = rawPrice is num ? rawPrice : (num.tryParse(rawPrice.toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 4599);

    final airlineColor = _getAirlineColor(airline);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Header: Airline badge & Flight Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: airlineColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: airlineColor.withAlpha(80)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flight_rounded, size: 14, color: airlineColor),
                          const SizedBox(width: 4),
                          Text(
                            airline,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: airlineColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      flightNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                Text(
                  CurrencyFormatter.formatInr(price),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Route timeline: Dep -> Duration -> Arr
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      depTime,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      origin,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 90,
                      child: Row(
                        children: [
                          Container(width: 5, height: 5, decoration: BoxDecoration(color: airlineColor, shape: BoxShape.circle)),
                          Expanded(child: Container(height: 1.5, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight)),
                          Icon(Icons.airplanemode_active, size: 12, color: airlineColor),
                          Expanded(child: Container(height: 1.5, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight)),
                          Container(width: 5, height: 5, decoration: BoxDecoration(color: airlineColor, shape: BoxShape.circle)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stops,
                      style: const TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      arrTime,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      destination,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Footer CTA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.luggage_outlined, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    const SizedBox(width: 4),
                    Text(
                      '7 kg Cabin + 15 kg Check-in',
                      style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onBookPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Select Flight', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAirlineColor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('indigo') || lower.contains('6e')) return AppColors.indigoAirline;
    if (lower.contains('air india') || lower.contains('ai')) return AppColors.airIndiaAirline;
    if (lower.contains('vistara') || lower.contains('uk')) return AppColors.vistaraAirline;
    if (lower.contains('spicejet') || lower.contains('sg')) return AppColors.spiceJetAirline;
    if (lower.contains('akasa') || lower.contains('qp')) return AppColors.akasaAirline;
    return AppColors.accent;
  }
}
