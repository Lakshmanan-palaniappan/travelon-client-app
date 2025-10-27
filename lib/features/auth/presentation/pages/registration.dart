import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/tourist.dart';
import '../bloc/tourist_bloc.dart';

class RegisterTouristPage extends StatefulWidget {
  const RegisterTouristPage({super.key});

  @override
  State<RegisterTouristPage> createState() => _RegisterTouristPageState();
}

class _RegisterTouristPageState extends State<RegisterTouristPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final picker = ImagePicker();
  File? kycFile;

  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nationalityCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final kycTypeCtrl = TextEditingController();
  final emergencyCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final kycNoCtrl = TextEditingController();

  Future<void> pickFile() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => kycFile = File(picked.path));
    }
  }

  void onSubmit() {
    if (_formKey.currentState!.validate() && kycFile != null) {
      final tourist = Tourist(
        name: nameCtrl.text,
        email: emailCtrl.text,
        password: passCtrl.text,
        nationality: nationalityCtrl.text,
        contact: contactCtrl.text,
        gender: genderCtrl.text,
        kycType: kycTypeCtrl.text,
        emergencyContact: emergencyCtrl.text,
        address: addressCtrl.text,
        kycNo: kycNoCtrl.text,
        agencyId: 1,
      );

      context.read<TouristBloc>().add(RegisterTouristEvent(tourist, kycFile!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and upload your KYC file."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final blue = Colors.blue.shade600;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Tourist Registration"),
        backgroundColor: blue,
        centerTitle: true,
      ),
      body: BlocConsumer<TouristBloc, TouristState>(
        listener: (context, state) {
          if (state is TouristRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Registered: ${state.response['message']}"),
              ),
            );

            // 🟦 Navigate to another screen after registration success
            Future.delayed(const Duration(seconds: 1), () {
              context.go('/home');
            });
          } else if (state is TouristError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
          }
        },

        builder: (context, state) {
          if (state is TouristLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: Stepper(
              type: StepperType.horizontal,
              elevation: 2,
              margin: const EdgeInsets.all(16),
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() => _currentStep += 1);
                } else {
                  onSubmit();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) setState(() => _currentStep -= 1);
              },
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: blue),
                            foregroundColor: blue,
                          ),
                          onPressed: details.onStepCancel,
                          child: const Text("Back"),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: details.onStepContinue,
                        child: Text(_currentStep == 2 ? "Submit" : "Next"),
                      ),
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: const SizedBox.shrink(),
                  isActive: _currentStep >= 0,
                  state:
                      _currentStep > 0 ? StepState.complete : StepState.indexed,
                  content: Column(
                    children: [
                      _buildField(nameCtrl, "Full Name"),
                      _buildField(
                        emailCtrl,
                        "Email",
                        keyboard: TextInputType.emailAddress,
                      ),
                      _buildField(passCtrl, "Password", obscure: true),
                      _buildField(nationalityCtrl, "Nationality"),
                      _buildField(
                        contactCtrl,
                        "Contact Number",
                        keyboard: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const SizedBox.shrink(),
                  isActive: _currentStep >= 1,
                  state:
                      _currentStep > 1 ? StepState.complete : StepState.indexed,
                  content: Column(
                    children: [
                      _buildField(genderCtrl, "Gender (Male/Female)"),
                      _buildField(
                        kycTypeCtrl,
                        "KYC Type (Passport, Aadhar, etc.)",
                      ),
                      _buildField(kycNoCtrl, "KYC Number"),
                      _buildField(addressCtrl, "Address"),
                    ],
                  ),
                ),
                Step(
                  title: const SizedBox.shrink(),
                  isActive: _currentStep >= 2,
                  state:
                      _currentStep == 2 ? StepState.editing : StepState.indexed,
                  content: Column(
                    children: [
                      _buildField(
                        emergencyCtrl,
                        "Emergency Contact",
                        keyboard: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: pickFile,
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          kycFile == null
                              ? "Upload KYC Document"
                              : "KYC File Selected",
                        ),
                      ),
                      if (kycFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            kycFile!.path.split('/').last,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        obscureText: obscure,
        validator: (v) => v == null || v.isEmpty ? "Required field" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue.shade800),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
