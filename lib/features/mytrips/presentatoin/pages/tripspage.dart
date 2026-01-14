import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Travelon/features/MyRequests/presentation/widgets/requesttile.dart';
import '../../../../core/utils/theme/AppColors.dart';

class Tripspage extends StatelessWidget {
  const Tripspage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          ),
        ),
        title: Text(
          "My Trips",
          style: TextStyle(
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔵 Ongoing Trips
            RequestTile(
              icon: Icons.directions_bus_filled_outlined,
              title: "Ongoing Trips",
              subtitle: "View your active trips",
              onTap: () {
                context.push('/mytrips/ongoing');
              },
            ),

            const SizedBox(height: 16),

            /// 🟢 Completed Trips
            RequestTile(
              icon: Icons.check_circle_outline,
              title: "Completed Trips",
              subtitle: "View your past trips",
              onTap: () {
                context.push('/mytrips/completed');
              },
            ),
          ],
        ),
      ),
    );
  }
}
