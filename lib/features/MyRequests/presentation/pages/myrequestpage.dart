import 'package:Travelon/core/utils/show_modalsheet.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/MyRequests/presentation/widgets/requesttile.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_bloc.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_state.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

import '../../../../core/utils/theme/AppColors.dart';

class Myrequestpage extends StatelessWidget {
  const Myrequestpage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.push('/menu'),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: theme.iconTheme.color,
          ),
        ),
        title: Text(
          "Trip Requests",
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        //backgroundColor: theme.colorScheme.surface,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthSuccess) {
            return const Center(child: Myloader());
          }

          final tourist = state.tourist;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RequestTile(
                  icon: Icons.add_location_alt_outlined,
                  title: "Ask For Approval",
                  subtitle: "Go on a new trip",
                  onTap: () {
                    // final tourist = context.read<AuthBloc>().state.tourist;

                    if (tourist == null) {
                      ErrorFlash.show(context, message: "User not logged in");
                      return;
                    }
                    _showAddLocationDialog(
                      context,
                      tourist,
                    ); // pass tourist properly later
                  },
                ),
                const SizedBox(height: 16),
                RequestTile(
                  icon: Icons.pending_actions_outlined,
                  title: "Pending Approvals",
                  subtitle: "View your Approval Status",
                  onTap: () {
                    print("Pending req button is clicked");
                    context.read<TripBloc>().add(
                      FetchTouristTrips(tourist.id!),
                    );

                    context.push('/requests/pending');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddLocationDialog(
    BuildContext context,
    Tourist? tourist,
  ) async {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    InputDecoration dialogInputDecoration({
      required String label,
      required IconData icon,
      required bool isDark,
    }) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
        prefixIcon: Icon(
          icon,
          color: theme.iconTheme.color,
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.4,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                theme.colorScheme.onSurface.withOpacity(0.38),
          ),
        ),
      );
    }

    Future<void> _pickDate(
      TextEditingController controller,
      String label,
    ) async {
      final today = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(today.year, today.month, today.day),
        lastDate: DateTime(2100),
        helpText: label,
        keyboardType: TextInputType.datetime,

        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).colorScheme.primary,
                onPrimary: theme.colorScheme.tertiary,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              'Add Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Agency ID
                  // TextField(
                  //   readOnly: true,
                  //   style: TextStyle(
                  //     color:
                  //         isDark
                  //             ? AppColors.Light.withOpacity(0.6)
                  //             : AppColors.Dark.withOpacity(0.6),
                  //   ),
                  //   controller: TextEditingController(
                  //     text: tourist!.agencyId.toString(),
                  //   ),
                  //   decoration: dialogInputDecoration(
                  //     label: 'Agencvy ID',
                  //     icon: Icons.apartment_outlined,
                  //     isDark: isDark,
                  //   ),
                  // ),

                  /// Agency Name (read-only)
                  BlocBuilder<AgencyBloc, AgencyState>(
                    builder: (context, state) {
                      String agencyName = "-";

                      if (state is AgencyLoaded) {
                        print("Agency Loaded 🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠");

                        final agency = state.agencies.firstWhereOrNull(
                          (a) => a.id == tourist!.agencyId,
                        );

                        agencyName = agency?.name ?? "-";
                      }

                      return TextField(
                        readOnly: true,
                        controller: TextEditingController(text: agencyName),
                        style: TextStyle(
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                        ),
                        decoration: dialogInputDecoration(
                          label: 'Agency',
                          icon: Icons.apartment_outlined,
                          isDark: isDark,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  /// Tourist ID
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      // text: tourist.id.toString(),
                      text: tourist!.name,
                    ),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                    decoration: dialogInputDecoration(
                      label: 'User',
                      icon: Icons.badge_outlined,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Start Date
                  TextField(
                    readOnly: true,
                    controller: startDateController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    decoration: dialogInputDecoration(
                      label: 'Start Date',
                      icon: Icons.calendar_today,
                      isDark: isDark,
                    ),
                    onTap:
                        () =>
                            _pickDate(startDateController, "Select Start Date"),
                  ),

                  const SizedBox(height: 12),

                  /// End Date
                  TextField(
                    readOnly: true,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    controller: endDateController,
                    decoration: dialogInputDecoration(
                      label: 'End Date',
                      icon: Icons.calendar_today_outlined,
                      isDark: isDark,
                    ),
                    onTap:
                        () => _pickDate(endDateController, "Select End Date"),
                  ),
                ],
              ),
            ),
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
                  return MyElevatedButton(
                    radius: 50.0,
                    color: Theme.of(context).colorScheme.secondary,
                    text: state is TripLoading ? "Loading..." : "Next",
                    onPressed: () {
                      if (state is TripLoading) return;

                      if (startDateController.text.isEmpty ||
                          endDateController.text.isEmpty) {
                        ErrorFlash.show(
                          context,
                          message: "Please select both start and end dates",
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
                  );
                },
              ),
            ],
          ),
    );
  }
}
