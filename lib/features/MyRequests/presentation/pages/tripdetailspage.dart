import 'package:Travelon/core/utils/datehelper.dart';
import 'package:Travelon/features/trip/domain/entities/trip.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:Travelon/features/trip/presentation/prsentatioin/widgets/AssignedEmployeeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:Travelon/core/utils/widgets/Flash/SuccessFlash.dart';


import '../../../../core/utils/theme/AppColors.dart';
import '../../../trip/domain/entities/assigned_employee.dart';

class TripDetailsPage extends StatefulWidget {
  final Trip trip;

  const TripDetailsPage({super.key, required this.trip});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  bool _showAllPlaces = false;
  int _employeeRating = 0;
  bool _reviewSubmitted = false;
  AssignedEmployee? _assignedEmployee;
  bool _ratingChecked = false;

  Future<void> _loadRatingStatus() async {
    if (widget.trip.status != 'COMPLETED') {
      _ratingChecked = true;
      return;
    }

    try {
      final repo = context.read<TripBloc>().tripRepository;
      final res = await repo.getRatingStatus(tripId: widget.trip.id);

      if (!mounted) return;

      if (res["rated"] == true) {
        _reviewSubmitted = true;
        _employeeRating = res["rating"] ?? 0;
      }
    } catch (_) {
      // fail silently → allow user to rate
    } finally {
      if (mounted) {
        setState(() {
          _ratingChecked = true; // ✅ mark check done
        });
      }
    }
  }





  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRatingStatus();
    });
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final places = widget.trip.places ?? [];


    final visiblePlaces = _showAllPlaces ? places : places.take(3).toList();


    return BlocProvider.value(
      value: context.read<TripBloc>()..add(FetchAssignedEmployee()),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          centerTitle: true,
          title: Text(
            "Trip #${widget.trip.id}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          leading: IconButton(
            onPressed: () => context.go('/trips'),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: theme.iconTheme.color,
            ),
          ),
        ),
        body: Stack(
          children: [
            // OUTER SCROLL (whole page)
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                if (widget.trip.status == 'COMPLETED' && _ratingChecked) ...[
                  const SizedBox(height: 16),
                  _buildReviewEmployeeCard(theme),
                ],


                const SizedBox(height: 16),
                _buildTripHeader(theme),


                //_buildReviewEmployeeCard(theme),


                const SizedBox(height: 32),

                _buildSectionHeader(
                  theme,
                  "Schedule",
                  "${places.length} Places",
                ),
                const SizedBox(height: 16),

                if (places.isEmpty)
                  _buildEmptyState(context)
                else
                  _buildScrollableSchedule(visiblePlaces, places, theme),

                const SizedBox(height: 20),
                Divider(color: theme.dividerColor),
                const SizedBox(height: 24),

                _buildAgencyButton(context, theme),

                const SizedBox(height: 120),
              ],
            ),

            // FAB for Assigned Employee
            Positioned(
              bottom: 30,
              right: 16,
              child: BlocBuilder<TripBloc, TripState>(
                buildWhen: (prev, curr) =>
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

                  if (state is! AssignedEmployeeLoaded || state.employee == null) {
                    return const SizedBox.shrink();
                  }
                  _assignedEmployee = state.employee;

                  return FloatingActionButton.extended(
                    heroTag: "employee_fab",
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: theme.colorScheme.onTertiary,
                    onPressed: () => _showEmployeePopup(context, state.employee!),
                    icon: Icon(
                      Icons.badge_rounded,
                      color: theme.brightness == Brightness.dark
                          ? AppColors.textPrimaryLight
                          : theme.iconTheme.color,
                    ),
                    label: Text(
                      "Your Guide",
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? AppColors.textPrimaryLight
                            : theme.textTheme.titleLarge?.color,
                      ),
                    ),
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Scrollable Schedule with Fade + Overlay Button ---
  Widget _buildScrollableSchedule(
      List visiblePlaces,
      List allPlaces,
      ThemeData theme,
      ) {
    const double viewportHeight = 300;

    return Column(
      children: [
        SizedBox(
          height: viewportHeight,
          child: Stack(
            children: [
              // Inner scroll list
              ListView.builder(
                itemCount: visiblePlaces.length,
                itemBuilder: (context, index) {
                  final place = visiblePlaces[index];
                  final isLast = index == visiblePlaces.length - 1;
                  return _buildTimelineTile(theme, place, isLast);
                },
              ),

              // Fade + "View more" overlay when collapsed
              if (!_showAllPlaces && allPlaces.length > 3)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.surface.withOpacity(0.0),
                          theme.colorScheme.surface.withOpacity(0.8),
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                    child: Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          setState(() {
                            _showAllPlaces = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24),
                            border:
                            Border.all(color: theme.colorScheme.tertiary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View more",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: theme.colorScheme.tertiary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // "View less" button when expanded
        if (_showAllPlaces && allPlaces.length > 3) ...[
          const SizedBox(height: 8),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                setState(() {
                  _showAllPlaces = false;
                });
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.colorScheme.tertiary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View less",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: theme.colorScheme.tertiary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // --- Employee Bottom Sheet ---
  void _showEmployeePopup(BuildContext context, dynamic employee) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AssignedEmployeeCard(employee: employee),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTile(ThemeData theme, dynamic place, bool isLast) {
    Color statusColor = place.status == 'COMPLETED'
        ? AppColors.success
        : place.status == 'IN_PROGRESS'
        ? AppColors.warning
        : AppColors.textDisabledLight;

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
                    color: theme.colorScheme.tertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                _showPlaceDialog(context, place);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.onTertiary),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.placeName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(place.scheduledDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
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

  // --- Place Dialog ---
  void _showPlaceDialog(BuildContext context, dynamic place) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Place Details",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        final theme = Theme.of(ctx);

        Color statusColor;
        switch (place.status) {
          case 'COMPLETED':
            statusColor = AppColors.success;
            break;
          case 'IN_PROGRESS':
            statusColor = AppColors.warning;
            break;
          default:
            statusColor = AppColors.error;
        }

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onTertiary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.place_rounded,
                        color: theme.iconTheme.color,
                        size: 26,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      place.placeName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Status chip
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(
                        place.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.tertiary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: theme.iconTheme.color,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Scheduled on ${formatDate(place.scheduledDate)}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Time card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.tertiary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: theme.iconTheme.color,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              (place.startTime != null && place.endTime != null)
                                  ? "Time: ${place.startTime} - ${place.endTime}"
                                  : "Time not specified",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.titleLarge?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // OK Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.tertiary,
                          foregroundColor: theme.colorScheme.onTertiary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "OK",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.brightness==Brightness.dark?AppColors.textPrimaryLight:theme.textTheme.titleLarge?.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim, _, child) {
        final offsetTween =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: anim.drive(offsetTween),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  // --- Other UI ---
  Widget _buildAgencyButton(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(theme, "Travel Partner", "Agency"),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: ()=>context.go('/agency/details'),
          icon: Icon(Icons.business_rounded,
              size: 20, color: theme.iconTheme.color),
          label: Text(
            "View Agency Details",
            style: TextStyle(color: theme.textTheme.bodyLarge?.color,fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary.withOpacity(0.5),
            foregroundColor: theme.colorScheme.onSecondary,
            elevation: 0,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.secondary),
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
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        const Spacer(),
        Text(
          trailing,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.titleLarge?.color,
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
        color: theme.colorScheme.tertiary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 18, color: theme.iconTheme.color),
              const SizedBox(width: 10),
              Text(
                "${formatDate(widget.trip.startDate)} — ${formatDate(widget.trip.endDate)}",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.iconTheme.color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.trip.status,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildReviewEmployeeCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Review Your Guide",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 12),

          // ✅ If already reviewed → ONLY show text
          if (_reviewSubmitted) ...[
            Row(
              children: [
                Text(
                  "You rated $_employeeRating / 5",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.star_rounded,
                  size: 25,
                  color: theme.colorScheme.secondary,
                ),
              ],
            ),
          ] else ...[
            // ⭐ Stars (only if not reviewed)
            Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _employeeRating = starIndex;
                    });
                  },
                  icon: Icon(
                    _employeeRating >= starIndex
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 32,
                    color: _employeeRating >= starIndex
                        ? theme.colorScheme.tertiary
                        : theme.iconTheme.color?.withOpacity(0.4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 12),

            // 📨 Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _employeeRating == 0 || _assignedEmployee == null
                    ? null
                    : () async {
                  try {
                    final employeeId = _assignedEmployee!.employeeId;

                    await context.read<TripBloc>().tripRepository.rateEmployee(
                      tripId: widget.trip.id,        // ✅ REQUIRED
                      employeeId: employeeId,
                      rating: _employeeRating,
                    );

                    if (!mounted) return;

                    setState(() {
                      _reviewSubmitted = true;
                    });

                    SuccessFlash.show(
                      context,
                      message: "Thanks! You rated $_employeeRating / 5 ⭐",
                      title: "Success",
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to submit rating")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: theme.colorScheme.onTertiary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Submit Review",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildEmptyState(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Text(
        "No schedule items for this trip.",
        style: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
    ),
  );
}
