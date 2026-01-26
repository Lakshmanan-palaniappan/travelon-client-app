import 'dart:io';

import 'package:Travelon/core/utils/DeviceType.dart';
import 'package:Travelon/core/utils/constants/nationalities.dart';
import 'package:Travelon/core/utils/dropdown_utils.dart';
import 'package:Travelon/core/utils/form_validators.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/Flash/WarningFlash.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyTextField.dart';
import 'package:Travelon/core/utils/widgets/SelectableOptionTile.dart';
import 'package:Travelon/core/utils/widgets/Flash/SuccessFlash.dart';
import 'package:Travelon/core/utils/widgets/my_dropdown_field.dart';
import 'package:Travelon/core/utils/widgets/my_file_picker_field.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_bloc.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_event.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_state.dart';
import 'package:Travelon/features/auth/data/models/tourist_model.dart';
import 'package:Travelon/features/auth/domain/entities/register_tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final emergencyCtrl = TextEditingController();
  final agencyCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final kycNoCtrl = TextEditingController();
  int? selectedAgencyId;
  String? selectedKycFileName;
  File? selectedKycFile;

  String? selectedGender;
  String? selectedNationality;
  String? selectedkycType;
  DeviceType? selectedDevice;

  final List<String> genderOptions = const ['Male', 'Female', 'Others'];

  // list of KYC types
  final List<String> KYCOptions = const ['Aadhar', 'Passport'];

  // late final List<_RegisterStep> _steps;

  List<_RegisterStep> get _steps => [
    _RegisterStep(
      title: "Personal Details",
      content: _personalStep(),
      helperText: "Enter Your Personal Details here",
    ),
    _RegisterStep(
      title: "Contact Information",
      content: _contactStep(),
      helperText: "Enter Your Contact Details here",
    ),
    _RegisterStep(
      title: "Device & Agency",
      content: _deviceStep(),
      helperText: "",
    ),
    _RegisterStep(
      title: "KYC / Identification",
      content: _kycStep(),
      helperText: "Enter Your KYC Details here",
    ),
    _RegisterStep(
      title: "Account Security",
      content: _securityStep(),
      helperText: "set password for your account",
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<AgencyBloc>().add(LoadAgencies());
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    contactCtrl.dispose();
    emergencyCtrl.dispose();
    agencyCtrl.dispose();
    addressCtrl.dispose();
    kycNoCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _back() {
    if (_currentStep == 0) {
      context.go("/landingpage");
    }
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is RegisterSuccess) {
          SuccessFlash.show(context, message: "Registration Successful 🎉");

          Future.delayed(const Duration(seconds: 2), () {
            context.go('/login');
          });
        } else if (state is AuthError) {
          ErrorFlash.show(context, message: state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: _back,
            ),
            title: Text(
              "New Registration",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,

              // autovalidateMode: AutovalidateMode.disabled,
              autovalidateMode: AutovalidateMode.onUserInteraction,

              child: Column(
                children: [
                  _progressIndicator(),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _steps[_currentStep].title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _steps[_currentStep].helperText,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Align(
                        key: ValueKey(_currentStep),
                        alignment: Alignment.topCenter, // ✅ FIX
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: _steps[_currentStep].content,
                        ),
                      ),
                    ),
                  ),

                  _bottomCTA(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ───────────────── PROGRESS ─────────────────

  Widget _progressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "0${_currentStep + 1}/${_steps.length}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ───────────────── STEP 1 ─────────────────

  Widget _personalStep() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          title: "Name",
          hintText: "Enter Name",
          controller: nameCtrl,
          required: true,
          validator: (value) => FormValidators.name(value, label: 'name'),
        ),
        MyDropdownField<String>(
          label: "Gender",
          hintText: "Select gender",
          required: true,
          items: DropdownUtils.buildDropdownItems(genderOptions),
          value: selectedGender,
          onChanged: (v) => setState(() => selectedGender = v),
        ),
        MyDropdownField<String>(
          label: "Nationality",
          hintText: "Select Nationality",
          value: selectedNationality,
          items: DropdownUtils.buildDropdownItems(Nationalities.all),
          onChanged: (v) => setState(() => selectedNationality = v),
          validator: (v) => v == null ? "Nationality is required" : null,
        ),
        _buildTextField(
          title: "City",
          hintText: "Enter City",
          controller: addressCtrl,
          required: true,
          validator: (value) => FormValidators.name(value, label: 'city'),
        ),
      ],
    );
  }

  // ───────────────── STEP 2 ─────────────────

  Widget _contactStep() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        _buildTextField(
          title: "Email",
          hintText: "Enter Email",
          controller: emailCtrl,
          required: true,
          validator: FormValidators.email,
        ),
        _buildTextField(
          title: "Contact",
          hintText: "Enter Contact No.",
          controller: contactCtrl,
          required: true,
        ),
        _buildTextField(
          title: "Emergency Contact",
          hintText: "Enter Alternate Contact No.",
          controller: emergencyCtrl,
        ),
      ],
    );
  }

  // ───────────────── STEP 3 ─────────────────

  Widget _deviceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Your Device Type.",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SelectableOptionTile(
          title: "Mobile",
          icon: Icons.smartphone,
          selected: selectedDevice == DeviceType.mobile,
          onTap:
              () => setState(() {
                selectedDevice = DeviceType.mobile;
              }),
        ),
        const SizedBox(height: 10),
        SelectableOptionTile(
          title: "Wearable",
          icon: Icons.watch,
          selected: selectedDevice == DeviceType.device,
          onTap:
              () => setState(() {
                selectedDevice = DeviceType.device;
              }),
        ),

        // _buildTextField(
        //   title: "Agency ID",
        //   hintText: "Enter agency ID",
        //   controller: agencyCtrl,
        //   required: true,
        // ),
        BlocBuilder<AgencyBloc, AgencyState>(
          builder: (context, state) {
            if (state is AgencyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AgencyLoaded) {
              return MyDropdownField<int>(
                label: "Select Agency",
                hintText: "Choose your agency",
                required: true,
                value: selectedAgencyId,
                // Map list of Agency objects to DropdownMenuItems
                items:
                    state.agencies.map((agency) {
                      return DropdownMenuItem<int>(
                        value: agency.id, // The "ID" is the value
                        child: Text(agency.name), // The "Name" is displayed
                      );
                    }).toList(),
                onChanged: (v) => setState(() => selectedAgencyId = v),
                validator: (v) => v == null ? "Please select an agency" : null,
              );
            } else if (state is AgencyError) {
              print("😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫");
              print(state.message);
              return Text(
                "Error loading agencies",
                style: TextStyle(color: Colors.red),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // ───────────────── STEP 4 ─────────────────

  Widget _kycStep() {
    return Column(
      children: [
        MyDropdownField<String>(
          required: true,
          label: "Document Type",
          hintText: "Select Document Type",
          items: DropdownUtils.buildDropdownItems(KYCOptions),
          value: selectedkycType,
          onChanged: (v) => setState(() => selectedkycType = v),
          validator: (v) => v == null ? "Document type is required" : null,
        ),

        _buildTextField(
          title: "KYC No.",
          hintText: "Enter KYC No.",
          controller: kycNoCtrl,
        ),
        SizedBox(height: 16.0),
        MyFilePickerField(
          hintText: "Upload KYC Document (PNG / JPG / PDF)",
          required: true,
          file: selectedKycFile,
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: const ['png', 'jpg', 'jpeg', 'pdf'],
            );

            if (result != null && result.files.single.path != null) {
              setState(() {
                selectedKycFile = File(result.files.single.path!);
              });
            }
          },
        ),
      ],
    );
  }
  // ───────────────── STEP 5 ─────────────────

  Widget _securityStep() {
    return Column(
      children: [
        _buildTextField(
          title: "Password",
          hintText: "Enter Password",
          controller: passCtrl,
          required: true,
          validator: FormValidators.password,
        ),
        _buildTextField(
          title: "Confirm Password",
          hintText: "Enter Confirm Password",
          controller: confirmPassCtrl,
          required: true,
          obscure: true,
          validator:
              (v) => FormValidators.confirmPassword(v, passCtrl.text.trim()),
        ),
      ],
    );
  }

  // ───────────────── CTA ─────────────────

  Widget _bottomCTA() {
    final isLast = _currentStep == _steps.length - 1;
    final authBloc = context.read<AuthBloc>(); // if using bloc

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: MyElevatedButton(
          text: isLast ? "Submit" : "Next",
          onPressed: () {
            if (!isLast) {
              if (_validateCurrentStep()) {
                _next();
              } else {
                _showStepError();
              }
              return;
            }

            // ✅ FINAL VALIDATION
            if (!_formKey.currentState!.validate()) return;

            if (selectedKycFile == null) {
              _showStepError();
              return;
            }

            // 🔥 CREATE TOURIST MODEL HERE
            final registerData = RegisterTouristEntity(
              name: nameCtrl.text.trim(),
              email: emailCtrl.text.trim(),
              contact: contactCtrl.text.trim(),
              emergencyContact: emergencyCtrl.text.trim(),
              nationality: selectedNationality!,
              gender: selectedGender!,
              address: addressCtrl.text.trim(),
              // agencyId: int.parse(agencyCtrl.text),
              agencyId: selectedAgencyId!,
              password: passCtrl.text.trim(),
              kycNo: kycNoCtrl.text.trim(),
              userType: selectedDevice?.name,
              kycType: selectedkycType,
            );

            authBloc.add(
              RegisterEvent(registerData, kycfile: selectedKycFile!),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    bool obscure = false,
    bool required = false,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Label + *
        RichText(
          text: TextSpan(
            text: title,
            style: textTheme.titleMedium,
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        MyTextField(
          hintText: hintText,
          ctrl: controller,
          obscure: obscure,
          validator:
              validator ??
              (required
                  ? (v) => v == null || v.isEmpty ? 'Please enter $title' : null
                  : null),
        ),
      ],
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return nameCtrl.text.isNotEmpty &&
            selectedGender != null &&
            selectedNationality != null &&
            addressCtrl.text.isNotEmpty;

      case 1:
        return emailCtrl.text.isNotEmpty && contactCtrl.text.isNotEmpty;

      case 2:
        // return selectedDevice != null;
        return selectedDevice != null &&
            selectedAgencyId != null; // Added check

      case 3:
        return selectedkycType != null && selectedKycFile != null;

      case 4:
        return _formKey.currentState!.validate();

      default:
        return false;
    }
  }

  void _showStepError() {
    WarningFlash.show(context, message: "Please complete required fields");
  }
}
// ───────────────── STEP MODEL ─────────────────

class _RegisterStep {
  final String title;
  final Widget content;
  final String helperText;

  _RegisterStep({
    required this.title,
    required this.content,
    required this.helperText,
  });
}
