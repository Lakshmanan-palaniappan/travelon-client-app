import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/Flash/SuccessFlash.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/core/utils/widgets/PlaceTile.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showPlacesModal(
  BuildContext context,
  int agencyId,
  int touristId,
) async {
  final tripBloc = context.read<TripBloc>();
  tripBloc.add(FetchAgencyPlaces(agencyId.toString()));
  final theme=Theme.of(context);
  final isDark=theme.brightness==Brightness.dark;

  final selectedPlaceIds = <int>{};

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final theme = Theme.of(context);

      return FractionallySizedBox(
        heightFactor: 0.85,
        widthFactor: screenWidth > 600 ? 0.7 : 1.0,
        child: BlocConsumer<TripBloc, TripState>(
          listener: (context, state) async {
            if (state is TripRequestSuccess) {
              final rootContext = Navigator.of(context).context;

              Navigator.pop(context); // close bottom sheet

              // Delay ensures bottom sheet is fully dismissed
              await Future.delayed(const Duration(milliseconds: 200));

              showTripSuccessAlert(rootContext);
            } else if (state is TripRequestError) {
              ErrorFlash.show(context, message: state.message);
            }
          },
          builder: (context, state) {
            if (state is TripLoading) {
              return const Center(child: Myloader());
            }

            if (state is TripLoaded) {
              final places = state.places;

              if (places.isEmpty) {
                return  Center(
                  child: Text("No places found for this agency.",style: TextStyle(
                        color:isDark?AppColors.primaryDark:AppColors.primaryLight

                  ),),

                );
              }

              return StatefulBuilder(
                builder: (context, setModalState) {
                  return Column(
                    children: [
                      // ── Drag Handle ──
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        height: 5,
                        width: 48,
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      // ── Title ──
                      Text(
                        "Select Places to Visit",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                              color:isDark?AppColors.primaryDark:AppColors.primaryLight

                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Places List ──
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final place = places[index];
                            final placeId = place['PlaceId'];
                            final isSelected = selectedPlaceIds.contains(
                              placeId,
                            );

                            return Placetile(
                              title: place['PlaceName'],
                              selected: isSelected,
                              onTap: () {
                                setModalState(() {
                                  isSelected
                                      ? selectedPlaceIds.remove(placeId)
                                      : selectedPlaceIds.add(placeId);
                                });
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── CTA Button ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: MyElevatedButton(
                            color: isDark
                                ? AppColors.primaryDark
                                : AppColors.primaryLight,
                            text: selectedPlaceIds.isEmpty
                                ? "Select at least one place"
                                : "Add ${selectedPlaceIds.length} place(s)",
                            icon: Icons.send,
                            onPressed: selectedPlaceIds.isEmpty
                                ? null
                                : () {
                              tripBloc.add(
                                SubmitTripWithPlaces(
                                  placeIds: selectedPlaceIds.toList(),
                                ),
                              );
                            },
                          ),

                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              );
            }

            if (state is TripError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );
    },
  );
}

void showTripSuccessAlert(BuildContext context) {
  final theme = Theme.of(context);
  final isDark=theme.brightness==Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        // ───── TITLE ─────
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Success",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark?AppColors.primaryDark:AppColors.primaryLight
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Trip request submitted successfully",
              style: theme.textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),

        // ───── CONTENT ─────
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
        content: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: isDark?AppColors.primaryDark:AppColors.primaryLight,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Your request has been sent. Please wait for confirmation.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),

        // ───── ACTION ─────
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: MyElevatedButton(
              radius: 30,
              text: "OK",
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      );
    },
  );
}
