import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/MyRequests/presentation/pages/tripdetailspage.dart';
import 'package:Travelon/features/MyRequests/presentation/widgets/requesttile.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OngoingTripsPage extends StatelessWidget {
  const OngoingTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final tourist = authState is AuthSuccess ? authState.tourist : null;

    if (tourist == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Ongoing Trips")),
      body: BlocProvider.value(
        value: context.read<TripBloc>()
          ..add(FetchTouristTrips(tourist.id!)),
        child: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TouristTripsLoading) {
              return const Myloader();
            }

            if (state is TouristTripsLoaded) {
              final ongoingTrips =
                  state.trips.where((t) => t.status == "ONGOING").toList();

              if (ongoingTrips.isEmpty) {
                return const Center(
                  child: Text("No ongoing trips"),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: ongoingTrips.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final trip = ongoingTrips[index];

                  return RequestTile(
                    icon: Icons.directions_bus_filled_outlined,
                    title: "Trip #${trip.id}",
                    subtitle:
                        "From ${trip.createdAt.toLocal().toString().split(' ')[0]}",
                        status: trip.status,
                    
                      onTap: () {
                        final tripWithPlaces = TripWithPlacesModel.fromTripModel(trip);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailsPage(trip: tripWithPlaces),
                        ),
                      );

                      // open trip details later
                    },
                  );
                },
              );
            }

            if (state is TripError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
