import 'package:Travelon/core/utils/datehelper.dart';
import 'package:Travelon/features/trip/domain/entities/trip.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:Travelon/features/trip/presentation/prsentatioin/widgets/AssignedEmployeeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TripDetailsPage extends StatelessWidget {
  final Trip trip;

  const TripDetailsPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final places = trip.places ?? [];

    return BlocProvider.value(
      // Ensure the Bloc is provided and fetch the employee specifically for this trip
      value: context.read<TripBloc>()..add(FetchAssignedEmployee()),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          centerTitle: true,
          title: Text(
            "Trip #${trip.id}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // 1. Header with Dates and Status
                _buildTripHeader(theme),

                const SizedBox(height: 32),

                // 2. Itinerary Section
                _buildSectionHeader(
                  theme,
                  "Schedule",
                  "${places.length} Places",
                ),
                const SizedBox(height: 16),

                if (places.isEmpty)
                  _buildEmptyState()
                else
                  _buildTimelineList(places, theme),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),

                // 3. Agency Details Section
                _buildAgencyButton(context,theme),

                // Extra padding to ensure content isn't hidden by the FAB
                const SizedBox(height: 120),
              ],
            ),

            // 4. Floating Action Button for Assigned Employee
            Positioned(
              bottom: 30,
              right: 16,
              child: BlocBuilder<TripBloc, TripState>(
                buildWhen:
                    (prev, curr) =>
                        curr is AssignedEmployeeLoaded ||
                        curr is AssignedEmployeeLoading ||
                        curr is AssignedEmployeeError,
                builder: (context, state) {
                  if (state is AssignedEmployeeLoading) {
                    return FloatingActionButton(
                      onPressed: null,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  if (state is! AssignedEmployeeLoaded ||
                      state.employee == null) {
                    return const SizedBox.shrink();
                  }

                  return FloatingActionButton.extended(
                    heroTag: "employee_fab",
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    onPressed:
                        () => _showEmployeePopup(context, state.employee!),
                    icon: const Icon(Icons.badge_rounded),
                    label: const Text("Your Guide"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper to show your custom card ---
  void _showEmployeePopup(BuildContext context, dynamic employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bottom sheet drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // The card you created previously
                AssignedEmployeeCard(employee: employee),
              ],
            ),
          ),
    );
  }

  // --- UI Component Builders ---

  Widget _buildTimelineList(List places, ThemeData theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        final isLast = index == places.length - 1;
        return _buildTimelineTile(theme, place, isLast);
      },
    );
  }

  Widget _buildAgencyButton(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(theme, "Service Provider", "Agency"),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to Agency details
            context.go('/agency/details');
          },
          icon: const Icon(Icons.business_rounded, size: 20),
          label: const Text("View Agency Details"),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            foregroundColor: theme.colorScheme.onSurfaceVariant,
            elevation: 0,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, String trailing) {
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          trailing,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

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
              const SizedBox(width: 10),
              Text(
                "${formatDate(trip.startDate)} — ${formatDate(trip.endDate)}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              trip.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile(ThemeData theme, dynamic place, bool isLast) {
    Color statusColor =
        place.status == 'COMPLETED' ? Colors.green : Colors.orange;

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Icon(Icons.check_circle, size: 20, color: statusColor),
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
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.placeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(place.scheduledDate),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Text("No schedule items for this trip."),
    ),
  );
}
