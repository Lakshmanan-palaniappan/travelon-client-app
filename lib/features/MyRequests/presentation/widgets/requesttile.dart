// import 'package:Travelon/core/utils/theme/AppColors.dart';
// import 'package:flutter/material.dart';

// class RequestTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;

//   const RequestTile({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark=theme.brightness==Brightness.dark;

//     return Material(
//       color: theme.scaffoldBackgroundColor,
//       borderRadius: BorderRadius.circular(10),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: isDark?AppColors.primaryDark:AppColors.primaryLight,
//             ),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 size: 28,
//                 color: isDark?AppColors.primaryDark:AppColors.primaryLight,
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                           color: isDark?AppColors.Light:AppColors.Dark
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: isDark?AppColors.Light:AppColors.Dark
//                       ),


//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.chevron_right_rounded,color: isDark?AppColors.primaryDark:AppColors.primaryLight),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:flutter/material.dart';

class RequestTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  // ✅ NEW (optional)
  final String? status;

  const RequestTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.status, // optional → old code still works
  });

  Color _statusColor(String status, bool isDark) {
    switch (status.toUpperCase()) {
      case 'ONGOING':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.yellowAccent;
      case 'CANCELLED':
        return Colors.red;
      default:
        return isDark ? AppColors.primaryDark : AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  theme.colorScheme.primary,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color:
                    theme.iconTheme.color,
              ),
              const SizedBox(width: 16),

              // 🔹 Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔖 STATUS BADGE (only if provided)
              if (status != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status!, isDark).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _statusColor(status!, isDark),
                    ),
                  ),
                  child: Text(
                    status!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _statusColor(status!, isDark),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              Icon(
                Icons.chevron_right_rounded,
                color:
                    isDark ? AppColors.primaryDark : AppColors.primaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

