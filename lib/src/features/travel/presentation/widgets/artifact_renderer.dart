import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../chat/domain/entities/chat_message.dart';
import 'booking_card.dart';
import 'flight_result_card.dart';
import 'hotel_result_card.dart';

/// Dynamic Artifact Renderer for rich Generative UI travel cards
class ArtifactRenderer extends StatelessWidget {
  final ArtifactRef artifact;
  final void Function(Map<String, dynamic>)? onItemSelected;

  const ArtifactRenderer({
    super.key,
    required this.artifact,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final payload = artifact.fullPayload?['payload'] ?? artifact.fullPayload ?? artifact.summary;
    final component = artifact.uiComponent.toLowerCase();

    // 1. Flight results
    if (component.contains('flight')) {
      return _buildFlightSection(context, payload);
    }

    // 2. Hotel results
    if (component.contains('hotel')) {
      return _buildHotelSection(context, payload);
    }

    // 3. Booking / Itinerary
    if (component.contains('booking') || component.contains('itinerary') || component.contains('pnr')) {
      return _buildBookingSection(context, payload);
    }

    // Default Fallback: Summary Card
    return _buildSummaryCard(context, artifact.summary);
  }

  Widget _buildFlightSection(BuildContext context, dynamic payload) {
    List<dynamic> items = [];
    if (payload is List) {
      items = payload;
    } else if (payload is Map<String, dynamic>) {
      if (payload['flights'] is List) {
        items = payload['flights'] as List;
      } else if (payload['results'] is List) {
        items = payload['results'] as List;
      } else if (payload['data'] is List) {
        items = payload['data'] as List;
      } else {
        items = [payload];
      }
    }

    if (items.isEmpty && artifact.summary.isNotEmpty) {
      return _buildSummaryCard(
        context,
        artifact.summary,
        icon: Icons.flight_takeoff_rounded,
        title: 'Flight Results',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4, top: 6),
          child: Row(
            children: [
              const Icon(Icons.flight_takeoff_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Available Flights (${items.length})',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ...items.map((item) {
          final data = item is Map<String, dynamic>
              ? item
              : <String, dynamic>{'raw': item.toString()};
          return FlightResultCard(
            flightData: data,
            onBookPressed: () => onItemSelected?.call(data),
          );
        }),
      ],
    );
  }

  Widget _buildHotelSection(BuildContext context, dynamic payload) {
    List<dynamic> items = [];
    if (payload is List) {
      items = payload;
    } else if (payload is Map<String, dynamic>) {
      if (payload['hotels'] is List) {
        items = payload['hotels'] as List;
      } else if (payload['results'] is List) {
        items = payload['results'] as List;
      } else {
        items = [payload];
      }
    }

    if (items.isEmpty && artifact.summary.isNotEmpty) {
      return _buildSummaryCard(
        context,
        artifact.summary,
        icon: Icons.hotel_rounded,
        title: 'Hotel Recommendations',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4, top: 6),
          child: Row(
            children: [
              const Icon(Icons.hotel_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Top Hotels (${items.length})',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ...items.map((item) {
          final data = item is Map<String, dynamic>
              ? item
              : <String, dynamic>{'raw': item.toString()};
          return HotelResultCard(
            hotelData: data,
            onBookPressed: () => onItemSelected?.call(data),
          );
        }),
      ],
    );
  }

  Widget _buildBookingSection(BuildContext context, dynamic payload) {
    final data = payload is Map<String, dynamic> ? payload : <String, dynamic>{};
    return BookingCard(bookingData: data);
  }

  Widget _buildSummaryCard(
    BuildContext context,
    Map<String, dynamic> summary, {
    IconData icon = Icons.widgets_outlined,
    String? title,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? artifact.uiComponent.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    summary.entries.map((e) => '${e.key}: ${e.value}').join(' • '),
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
      ),
    );
  }
}
