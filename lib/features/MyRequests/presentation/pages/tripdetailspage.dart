import 'package:Travelon/core/utils/datehelper.dart';
import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';
import 'package:flutter/material.dart';

class TripDetailsPage extends StatelessWidget {
  final TripWithPlacesModel trip;

  const TripDetailsPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          "Trip #${trip.trip.id}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // --- Main Trip Header ---
          _buildTripHeader(theme),

          const SizedBox(height: 32),

          // --- Section Title ---
          Row(
            children: [
              Text(
                "Itinerary",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              Text(
                "${trip.places.length} Stops",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Places Timeline ---
          ListView.builder(
            shrinkWrap: true, // Needed inside another ListView
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trip.places.length,
            itemBuilder: (context, index) {
              final place = trip.places[index];
              final isLast = index == trip.places.length - 1;
              return _buildTimelineTile(theme, place, isLast);
            },
          ),
        ],
      ),
    );
  }

  // Header Card with iOS soft shadow
  Widget _buildTripHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "${formatDate(trip.startDate)} — ${trip.endDate != null ? formatDate(trip.endDate!) : 'Ongoing'}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trip.trip.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Timeline UI for Places
  Widget _buildTimelineTile(ThemeData theme, dynamic place, bool isLast) {
    Color statusColor;
    IconData statusIcon;

    switch (place.status) {
      case 'COMPLETED':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'IN_PROGRESS':
        statusColor = Colors.orange;
        statusIcon = Icons.directions_run_rounded;
        break;
      default:
        statusColor = theme.colorScheme.outline;
        statusIcon = Icons.radio_button_unchecked_rounded;
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline line and indicator
          Column(
            children: [
              Icon(statusIcon, size: 24, color: statusColor),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Place Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        place.placeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        place.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(place.scheduledDate),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
