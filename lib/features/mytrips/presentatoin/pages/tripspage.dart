import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Travelon/features/MyRequests/presentation/widgets/requesttile.dart';

class Tripspage extends StatelessWidget {
  const Tripspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: const Text("My Trips"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RequestTile(
              icon: Icons.directions_bus_filled_outlined,
              title: "Ongoing Trips",
              subtitle: "View your active trips",
              onTap: () {
                context.push('/trips/ongoing');
              },
            ),
            const SizedBox(height: 16),
            RequestTile(
              icon: Icons.check_circle_outline,
              title: "Completed Trips",
              subtitle: "View your past trips",
              onTap: () {
                context.push('/trips/completed');
              },
            ),
          ],
        ),
      ),
    );
  }
}
