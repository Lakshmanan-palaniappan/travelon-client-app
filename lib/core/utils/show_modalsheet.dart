import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/Flash/SuccessFlash.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
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
              Navigator.pop(context);
              SuccessFlash.show(context, message: state.message);
              await Future.delayed(const Duration(seconds: 1));
            } else if (state is TripRequestError) {
              ErrorFlash.show(context, message: state.message);
            }
          },
          builder: (context, state) {
            if (state is TripLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TripLoaded) {
              final places = state.places;

              if (places.isEmpty) {
                return const Center(
                  child: Text("No places found for this agency."),
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
                            text:
                                selectedPlaceIds.isEmpty
                                    ? "Select at least one place"
                                    : "Add ${selectedPlaceIds.length} place(s)",
                            icon: Icons.send,
                            onPressed:
                                selectedPlaceIds.isEmpty
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
