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
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;

      return FractionallySizedBox(
        heightFactor: 0.85,
        widthFactor: screenWidth > 600 ? 0.7 : 1.0,
        child: BlocConsumer<TripBloc, TripState>(
          listener: (context, state) async {
            // 🔹 When trip is successfully added
            if (state is TripRequestSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              // 🔹 Delay 1 second before closing to show feedback
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop(context);
            } else if (state is TripRequestError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
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
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Text(
                        "Select Places to Visit",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final place = places[index];
                            final isSelected = selectedPlaceIds.contains(
                              place['PlaceId'],
                            );
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    selectedPlaceIds.remove(place['PlaceId']);
                                  } else {
                                    selectedPlaceIds.add(place['PlaceId']);
                                  }
                                });
                              },
                              child: Placetile(
                                title: place['PlaceName'],
                                width: screenWidth > 600 ? 500 : null,
                                color:
                                    isSelected
                                        ? Colors.blue.withOpacity(0.15)
                                        : Colors.transparent,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 🔹 Button shows how many places selected
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.send),
                        label: Text(
                          selectedPlaceIds.isEmpty
                              ? "Select at least one place"
                              : "Add ${selectedPlaceIds.length} place(s)",
                        ),
                        onPressed:
                            selectedPlaceIds.isEmpty
                                ? null
                                : () {
                                  // 🔹 Trigger trip creation event
                                  tripBloc.add(
                                    SubmitTripWithPlaces(
                                      touristId: touristId.toString(),
                                      agencyId: agencyId.toString(),
                                      placeIds: selectedPlaceIds.toList(),
                                    ),
                                  );
                                },
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
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return const Center(child: Text("Loading..."));
          },
        ),
      );
    },
  );
}
