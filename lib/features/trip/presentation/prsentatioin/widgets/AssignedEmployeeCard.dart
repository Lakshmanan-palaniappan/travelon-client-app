import 'package:Travelon/core/utils/services/url_launcher_service.dart';
import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:flutter/material.dart';

class AssignedEmployeeCard extends StatelessWidget {
  final AssignedEmployee employee;

  const AssignedEmployeeCard({super.key, required this.employee});

  String normalizeNumber(String number) {
    number = number.replaceAll(RegExp(r'\s+|-'), '');
    if (number.startsWith('+91')) {
      return number;
    }
    if (number.startsWith('0')) {
      number = number.substring(1);
    }
    return '+91$number';
  }

  // WhatsApp needs digits only: 919876543210 (NO +, NO spaces)
  String normalizeForWhatsApp(String number) {
    number = number.replaceAll(RegExp(r'[^0-9]'), '');
    if (number.startsWith('91')) {
      return number;
    }
    return '91$number';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── HERO SECTION ───
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(theme),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.employeeName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.8,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: theme.iconTheme.color,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              employee.rating.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        employee.agencyName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.titleLarge?.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ─── LANGUAGES CHIPS ───
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          employee.languages
              .map((lang) => _buildLanguageChip(theme, lang))
              .toList(),
        ),

        const SizedBox(height: 24),

        // ─── INFO GROUP ───
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                context,
                icon: Icons.work_outline_rounded,
                label: 'Category',
                value: employee.category,
              ),
              _buildDivider(),
              _buildDetailRow(
                context,
                icon: Icons.email_outlined,
                label: 'Email Address',
                value: employee.email,
              ),
              _buildDivider(),
              _buildDetailRow(
                context,
                icon: Icons.phone_iphone_rounded,
                label: 'Phone',
                value: employee.phone,
                isLast: true,
                actionWidget: _buildContactMenu(context, theme),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── CONTACT MENU (⋮) ───
  Widget _buildContactMenu(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        final phone = normalizeNumber(employee.phone);
        final waPhone = normalizeForWhatsApp(employee.phone);
        final message =
            "Hello ${employee.employeeName}, I'm contacting you regarding the trip.";

        if (value == 'call') {
          UrlLauncherService.makePhoneCall(phone);
        } else if (value == 'sms') {
          UrlLauncherService.sendSMS(phone, message);
        } else if (value == 'whatsapp') {
          UrlLauncherService.openWhatsApp(waPhone, message);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'call',
          child: Row(
            children: [
              Icon(Icons.phone, color: theme.iconTheme.color),
              const SizedBox(width: 12),
              const Text('Call'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'sms',
          child: Row(
            children: [
              Icon(Icons.sms, color: theme.iconTheme.color),
              const SizedBox(width: 12),
              const Text('Send SMS'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'whatsapp',
          child: Row(
            children: [
              const Icon(Icons.chat, color: Colors.green),
              const SizedBox(width: 12),
              const Text('Open WhatsApp'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 36,
          color: theme.iconTheme.color,
        ),
      ),
    );
  }

  Widget _buildLanguageChip(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.tertiary),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.titleLarge?.color,
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
        bool isLast = false,
        Widget? actionWidget,
      }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: theme.iconTheme.color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w800,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          if (actionWidget != null) actionWidget,
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 20, endIndent: 20);
}