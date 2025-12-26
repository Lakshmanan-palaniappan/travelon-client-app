import 'package:Travelon/core/utils/show_modalsheet.dart';
import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyOutlineButton.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Drawer(
      backgroundColor: scheme.surface,
      child: Column(
        children: [
          // ── Header ──
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String name = "Guest";
              String email = "";
              String contact = "";

              if (state is AuthSuccess) {
                name = state.tourist.name;
                email = state.tourist.email ?? "";
                contact = state.tourist.contact;
              }

              return DrawerHeader(
                decoration: BoxDecoration(color: scheme.primary),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      if (contact.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          contact,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onPrimary.withOpacity(0.9),
                          ),
                        ),
                      ],

                      if (email.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onPrimary.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Menu Items ──
          _drawerItem(
            context,
            icon: Icons.home,
            title: "Home",
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            context,
            icon: Icons.person_2_rounded,
            title: "My Profile",
            onTap: () {
              context.go('/profile');
            },
          ),

          _drawerItem(
            context,
            icon: Icons.history,
            title: "Request Trip",
            onTap: () {
              context.go('/request');
            },
          ),
          _drawerItem(
            context,
            icon: Icons.card_travel,
            title: "My Trips",
            onTap: () {
              context.go('/trips');
            },
          ),

          _drawerItem(
            context,
            icon: Icons.settings,
            title: "Settings",
            onTap: () {
              context.go('/settings');
            },
          ),

          const Spacer(),

          // _drawerItem(
          //   context,
          //   icon: Icons.logout,
          //   title: "Logout",
          //   onTap: () {
          //     _confirmLogout(context);
          //   },
          //   isDestructive: true,
          // ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      leading: Icon(
        icon,
        color: isDestructive ? scheme.error : scheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? scheme.error : scheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _showAddLocationDialog(
    BuildContext context,
    Tourist tourist,
  ) async {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            /// 📅 Date Picker
            Future<void> _pickDate(
              TextEditingController controller,
              String label,
            ) async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                helpText: label,
              );

              if (picked != null) {
                controller.text =
                    "${picked.day.toString().padLeft(2, '0')}/"
                    "${picked.month.toString().padLeft(2, '0')}/"
                    "${picked.year}";

                setDialogState(() {}); // 🔥 FORCE REBUILD
              }
            }

            final theme = Theme.of(context);

            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              // ───── TITLE ─────
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Request Trip",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Select your travel dates",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // ───── CONTENT ─────
              contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              content: SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.9, // 🔥 wider dialog
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      myReadonlyField(
                        context: context,
                        hintText: "Agency ID",
                        value: tourist.agencyId.toString(),
                        icon: Icons.apartment_outlined,
                      ),

                      myReadonlyField(
                        context: context,
                        hintText: "Tourist ID",
                        value: tourist.name.toString(),
                        icon: Icons.badge_outlined,
                      ),

                      const SizedBox(height: 16),

                      dateTile(
                        context: context,
                        hintText: "Start Date",
                        controller: startDateController,
                        onTap:
                            () => _pickDate(
                              startDateController,
                              "Select Start Date",
                            ),
                      ),

                      dateTile(
                        context: context,
                        hintText: "End Date",
                        controller: endDateController,
                        onTap:
                            () =>
                                _pickDate(endDateController, "Select End Date"),
                      ),
                    ],
                  ),
                ),
              ),

              // ───── ACTION ─────
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              actions: [
                BlocConsumer<TripBloc, TripState>(
                  listener: (context, state) {
                    if (state is TripRequestSuccess) {
                      Navigator.pop(context);
                      showPlacesModal(
                        context,
                        tourist.agencyId,
                        int.parse(tourist.id ?? '0'),
                      );
                    }

                    if (state is TripRequestError) {
                      ErrorFlash.show(context, message: state.message);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is TripLoading;

                    return Row(
                      children: [
                        /// ❌ Cancel Button
                        Expanded(
                          child: MyOutlinedButton(
                            text: "Cancel",
                            onPressed:
                                isLoading
                                    ? null
                                    : () async {
                                      Navigator.pop(context);

                                      /// OPTIONAL (Recommended UX)
                                      /// If user cancels before submitting places,
                                      /// clear pending requestId
                                      await TokenStorage.clearRequestId();
                                    },
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// ✅ Continue Button
                        Expanded(
                          child: MyElevatedButton(
                            radius: 30,
                            text: isLoading ? "Requesting..." : "Continue",
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      if (startDateController.text.isEmpty ||
                                          endDateController.text.isEmpty) {
                                        ErrorFlash.show(
                                          context,
                                          message:
                                              "Please select both start and end dates",
                                        );
                                        return;
                                      }

                                      context.read<TripBloc>().add(
                                        SubmitTripRequest(
                                          touristId: tourist.id.toString(),
                                          agencyId: tourist.agencyId.toString(),
                                          startDate: startDateController.text,
                                          endDate: endDateController.text,
                                        ),
                                      );
                                    },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget myReadonlyField({
    required BuildContext context,
    required String hintText,
    required String value,
    required IconData icon,
    double radius = 12,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasValue = value.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: scheme.onSurfaceVariant),
          filled: true,
          fillColor: scheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              width: 0.5, // ✅ SAME AS dateTile
              color: scheme.onPrimary,
            ),
          ),
        ),
        child: Text(
          hasValue ? value : hintText,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: hasValue ? scheme.onSurface : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget dateTile({
    required BuildContext context,
    required String hintText,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasValue = controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(Icons.calendar_today, color: scheme.primary),
            filled: true,
            fillColor: scheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0.5, color: scheme.onSurface),
              // borderSide: BorderSide.none,
            ),
          ),
          child: Text(
            hasValue ? controller.text : hintText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: hasValue ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
