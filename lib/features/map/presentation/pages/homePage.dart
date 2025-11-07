import 'package:Travelon/core/utils/widgets/ErrorCard.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        Tourist? tourist;
        if (state is AuthSuccess) {
          tourist = state.tourist;
        }

        if (tourist == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Page'),
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () async {
                  final shouldLogout = await _confirmLogout(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(LogoutEvent());
                  }
                },
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _showAddLocationDialog(context, tourist),
          ),
        );
      },
    );
  }

  Future<void> _showAddLocationDialog(
    BuildContext context,
    Tourist? tourist,
  ) async {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

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
            title: const Text(
              'Add Location',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: tourist!.agencyId.toString(),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Agency ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.apartment_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: tourist!.id.toString(),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Tourist ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap:
                        () =>
                            _pickDate(startDateController, "Select Start Date"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    onTap:
                        () => _pickDate(endDateController, "Select End Date"),
                  ),
                ],
              ),
            ),
            actions: [
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 32,
              //       vertical: 12,
              //     ),
              //   ),
              //   onPressed: () {
              //     if (startDateController.text.isEmpty ||
              //         endDateController.text.isEmpty) {
              //       showErrorFlash(
              //         context,
              //         "Please select both start and end dates",
              //       );
              //       return;
              //     }
              //     // TODO: handle submission of the dates
              //     Navigator.pop(context);
              //   },
              //   child: const Text("Next"),
              // ),
              Myelevatedbutton(
                show_text: "Next",
                onPressed: () {
                  if (startDateController.text.isEmpty ||
                      endDateController.text.isEmpty) {
                    showErrorFlash(
                      context,
                      "Please select both start and end dates",
                    );
                    return;
                  }
                  // TODO: handle submission of the dates
                  Navigator.pop(context);
                  // ✅ Open bottom sheet
                  showModalBottomSheet(
                    useSafeArea: true,
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Dates Selected',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              Text('Start: ${startDateController.text}'),
                              Text('End: ${endDateController.text}'),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                radius: 50.0,
              ),
            ],
          ),
    );
  }

  Future<bool> _confirmLogout(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
