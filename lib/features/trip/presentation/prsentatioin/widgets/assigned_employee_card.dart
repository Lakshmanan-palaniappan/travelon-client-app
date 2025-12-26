import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:flutter/material.dart';

class AssignedEmployeeCard extends StatelessWidget {
  final AssignedEmployee employee;

  const AssignedEmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.employeeName, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(employee.category),
            Text("⭐ ${employee.rating}"),
            const SizedBox(height: 8),
            Text("📞 ${employee.phone}"),
            Text("✉️ ${employee.email}"),
            Text("🏪 ${employee.agencyName}"),
            const SizedBox(height: 8),
            Text("Languages: ${employee.languages.join(', ')}"),
          ],
        ),
      ),
    );
  }
}
