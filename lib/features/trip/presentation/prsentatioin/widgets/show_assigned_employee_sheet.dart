import 'package:flutter/material.dart';
import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:Travelon/features/trip/presentation/prsentatioin/widgets/assigned_employee_card.dart';

void showAssignedEmployeeSheet(
  BuildContext context,
  AssignedEmployee employee,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      final theme = Theme.of(context);

      return DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.75,
        builder: (_, controller) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  // ── drag handle ──
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // AssignedEmployeecard(employee: employee),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
