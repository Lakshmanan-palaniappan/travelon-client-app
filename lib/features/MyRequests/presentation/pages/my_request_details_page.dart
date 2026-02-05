import 'package:Travelon/core/utils/datehelper.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/features/MyRequests/domain/entities/trip_request.dart';
import 'package:flutter/material.dart';

class MyRequestDetailsPage extends StatelessWidget {
  final TripRequest request;

  const MyRequestDetailsPage({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(request.status, theme);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Details"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.assignment_outlined,
                    size: 40, color: theme.iconTheme.color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Request #${request.requestId}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            "Status:",
                            style: theme.textTheme.bodyMedium,
                          ),
                          Chip(
                            label: Text(
                              request.status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: statusColor.withOpacity(0.12),
                            side: BorderSide(color: statusColor.withOpacity(0.4)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ===== REQUEST INFO =====
          _buildInfoCard(
            theme,
            icon: Icons.info_outline,
            title: "Request Information",
            children: [
              _buildRow("Request ID", "#${request.requestId}"),
              _buildRow(
                "Dates",
                "${formatDate(request.startDate)} → ${formatDate(request.endDate)}",
              ),
              _buildRow("Status", request.status),
              if (request.agencyName != null)
                _buildRow("Agency", request.agencyName!),
              if (request.employeeName != null)
                _buildRow("Assigned To", request.employeeName!),
            ],
          ),

          const SizedBox(height: 24),

          // ===== PLACES =====
          _buildInfoCard(
            theme,
            icon: Icons.place_outlined,
            title: "Selected Places",
            children: request.places.isEmpty
                ? [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("No places selected yet"),
              ),
            ]
                : request.places.map((p) {
              final subtitle = [
                p.city,
                p.state,
                p.country,
              ].where((e) => e != null && e!.isNotEmpty).join(", ");

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                  theme.colorScheme.surfaceVariant.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.place,
                        color: theme.iconTheme.color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.placeName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (subtitle.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                subtitle,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // ===== ACTION =====
          if (request.status.toLowerCase() == "pending")
            MyElevatedButton(
              text: "Request Pending",
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  // ================= UI Helpers =================

  Widget _buildInfoCard(
      ThemeData theme, {
        required IconData icon,
        required String title,
        required List<Widget> children,
      }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _statusColor(String status, ThemeData theme) {
    final s = status.toLowerCase();
    if (s == "pending") return Colors.orange;
    if (s == "approved" || s == "assigned") return Colors.blue;
    if (s == "completed") return Colors.green;
    if (s == "rejected" || s == "cancelled") return Colors.red;
    return theme.colorScheme.primary;
  }
}
