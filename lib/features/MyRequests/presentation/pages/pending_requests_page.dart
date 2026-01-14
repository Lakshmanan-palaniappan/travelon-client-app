import 'package:Travelon/core/utils/datehelper.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/MyRequests/presentation/widgets/requesttile.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingRequestsPage extends StatelessWidget {
  const PendingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthBloc>().state;
    final tourist = auth is AuthSuccess ? auth.tourist : null;

    if (tourist == null) {
      return const Scaffold(body: Center(child: Text("Not logged in")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Pending Requests")),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state is TouristTripsLoading) {
            return const Myloader();
          }

          if (state is TouristTripsLoaded) {
            final pendingTrips =
                state.trips.where((t) => t.status == "PENDING").toList();

            if (pendingTrips.isEmpty) {
              return const Center(child: Text("No pending requests"));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pendingTrips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final trip = pendingTrips[index];

                return RequestTile(
                  icon: Icons.pending_actions,
                  title: "Request #${trip.id}",
                  subtitle: "From ${formatDate(trip.createdAt)}",
                  status: trip.status,
                  onTap: () {

                    
                    // later: cancel / view details
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
    );
  }
}
