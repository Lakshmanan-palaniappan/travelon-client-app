import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/MyRequests/presentation/pages/tripdetailspage.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedTripsPage extends StatelessWidget {
  const CompletedTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final tourist = authState is AuthSuccess ? authState.tourist : null;

    if (tourist == null) {
      return const Scaffold(body: Center(child: Text("Not logged in")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Completed Trips")),
      body: BlocProvider.value(
        value: context.read<TripBloc>()..add(FetchTouristTrips(tourist.id!)),
        child: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TouristTripsLoading) {
              return const Myloader();
            }

            if (state is TouristTripsLoaded) {
              final completedTrips =
                  state.trips.where((t) => t.status == "COMPLETED").toList();

              if (completedTrips.isEmpty) {
                return const Center(child: Text("No completed trips"));
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children:
                    completedTrips
                        .map(
                          (trip) => Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              title: Text("Trip #${trip.id}"),
                              subtitle: Text(
                                "Completed on ${trip.completedAt?.toLocal().toString().split(' ')[0] ?? '-'}",
                              ),
                              trailing: Text(
                                trip.status,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                // TODO: view trip summary
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => TripDetailsPage(
                                          trip: trip,
                                        ), // Passing the Trip entity directly
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        .toList(),
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
