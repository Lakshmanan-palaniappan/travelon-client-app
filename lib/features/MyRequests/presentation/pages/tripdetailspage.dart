// import 'package:Travelon/core/utils/datehelper.dart';
// import 'package:Travelon/features/trip/data/models/trip_model.dart';
// import 'package:flutter/material.dart';

// class TripDetailsPage extends StatelessWidget {
//   final TripModel trip;

//   const TripDetailsPage({super.key, required this.trip});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Trip #${trip.id}")),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // HEADER
//           Card(
//             child: ListTile(
//               title: Text(
//                 "${formatDate(trip.createdAt)} → ${trip.completedAt != null ? formatDate(trip.completedAt!) : '—'}",
//               ),
//               subtitle: Text("Status: ${trip.status}"),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // PLACES
//           ...trip.places.map((place) => Card(
//                 child: ListTile(
//                   title: Text(place.placeName),
//                   subtitle: Text(formatDate(place.scheduledDate)),
//                   trailing: Text(place.status),
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
