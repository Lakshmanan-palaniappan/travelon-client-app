import 'package:Travelon/core/utils/datehelper.dart';
import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';
import 'package:flutter/material.dart';

class TripDetailsPage extends StatelessWidget {
  final TripWithPlacesModel trip;

  const TripDetailsPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trip #${trip.trip.id}")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// HEADER
          Card(
            child: ListTile(
              title: Text(
                "${formatDate(trip.startDate)} → "
                "${trip.endDate != null ? formatDate(trip.endDate!) : '—'}",
              ),
              subtitle: Text("Status: ${trip.trip.status}"),
            ),
          ),

          const SizedBox(height: 16),

          /// PLACES
          ...trip.places.map(
            (place) => Card(
              child: ListTile(
                title: Text(place.placeName),
                subtitle: Text(formatDate(place.scheduledDate)),
                trailing: Text(
                  place.status,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
