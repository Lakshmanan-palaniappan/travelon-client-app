import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Travelon/features/MyRequests/presentation/widgets/requesttile.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/menu'),
          icon: Icon(Icons.arrow_back_ios_rounded, color: theme.iconTheme.color),
        ),
        title: Text("My Alerts",
            style: TextStyle(color: theme.textTheme.titleLarge?.color)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RequestTile(
              icon: Icons.warning_amber_rounded,
              title: "Geofence Alerts",
              subtitle: "Danger zone alerts",
              onTap: () => context.push('/alerts/geofence'),
            ),
            const SizedBox(height: 16),
            RequestTile(
              icon: Icons.sos_rounded,
              title: "SOS Alerts",
              subtitle: "Emergency alerts",
              onTap: () => context.push('/alerts/sos'), // later
            ),
          ],
        ),
      ),
    );
  }
}
