import 'package:Travelon/core/utils/show_modalsheet.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/MyRequests/presentation/widgets/requesttile.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/theme/AppColors.dart';

class Myrequestpage extends StatelessWidget {
  const Myrequestpage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark=theme.brightness==Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.push('/menu'),
          icon: Icon(Icons.arrow_back_ios_rounded,color: isDark?AppColors.primaryDark:AppColors.primaryLight,),
        ),
        title: Text("My Requests",style: TextStyle(
            color: isDark?AppColors.primaryDark:AppColors.primaryLight
        ),),
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
                  title: "New Request",
                  subtitle: "Create a new trip request",
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
                  title: "Pending Request",
                  subtitle: "View your pending requests",
                  onTap: () {
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
    final theme=Theme.of(context);
    final isDark=theme.brightness==Brightness.dark;
    InputDecoration dialogInputDecoration({
      required String label,
      required IconData icon,
      required bool isDark,
    }) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.Light
              : AppColors.Dark,
        ),
        prefixIcon: Icon(
          icon,
          color: isDark
              ? AppColors.primaryDark
              : AppColors.primaryLight,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.primaryDark
                : AppColors.primaryLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.primaryDark
                : AppColors.primaryLight,
            width: 1.4,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.primaryDark.withOpacity(0.6)
                : AppColors.primaryLight.withOpacity(0.6),
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
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).colorScheme.primary,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              style: TextStyle(fontWeight: FontWeight.bold,color: isDark?AppColors.primaryDark:AppColors.primaryLight),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Agency ID
                  TextField(
                    readOnly: true,
                    style: TextStyle(
                        color:isDark?AppColors.Light.withOpacity(0.6):AppColors.Dark.withOpacity(0.6)
                    ),
                    controller: TextEditingController(
                      text: tourist!.agencyId.toString(),
                    ),
                    decoration: dialogInputDecoration(
                      label: 'Agency ID',
                      icon: Icons.apartment_outlined,
                      isDark: isDark,

                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Tourist ID
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: tourist.id.toString(),
                    ),
                    style: TextStyle(
                        color:isDark?AppColors.Light.withOpacity(0.6):AppColors.Dark.withOpacity(0.6)
                    ),
                    decoration: dialogInputDecoration(
                      label: 'Tourist ID',
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
                        color:isDark?AppColors.Light:AppColors.Dark
                    ),
                    decoration: dialogInputDecoration(
                      label: 'Start Date',
                      icon: Icons.calendar_today,
                      isDark: isDark,
                    ),
                    onTap: () =>
                        _pickDate(startDateController, "Select Start Date"),
                  ),

                  const SizedBox(height: 12),

                  /// End Date
                  TextField(
                    readOnly: true,
                    style: TextStyle(
                        color:isDark?AppColors.Light:AppColors.Dark
                    ),
                    controller: endDateController,
                    decoration: dialogInputDecoration(
                      label: 'End Date',
                      icon: Icons.calendar_today_outlined,
                      isDark: isDark,
                    ),
                    onTap: () =>
                        _pickDate(endDateController, "Select End Date"),
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
                    color: isDark?AppColors.primaryLight:AppColors.darkSecondary,
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
