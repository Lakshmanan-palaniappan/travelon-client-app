
import 'dart:io';

import 'package:Travelon/core/utils/DeviceType.dart';
import 'package:Travelon/core/utils/constants/nationalities.dart';
import 'package:Travelon/core/utils/dropdown_utils.dart';
import 'package:Travelon/core/utils/form_validators.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  static const String _draftKey = 'registration_draft';


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

  final List<String> KYCOptions = const ['Aadhar', 'Passport'];

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
  Future<void> _saveDraft() async {
  final prefs = await SharedPreferences.getInstance();

  final data = {
    "step": _currentStep,
    "name": nameCtrl.text,
    "email": emailCtrl.text,
    "contact": contactCtrl.text,
    "emergency": emergencyCtrl.text,
    "city": addressCtrl.text,
    "kycNo": kycNoCtrl.text,
    "gender": selectedGender,
    "nationality": selectedNationality,
    "kycType": selectedkycType,
    "device": selectedDevice?.name,
    "agencyId": selectedAgencyId,
    "kycFilePath": selectedKycFile?.path,
  };

  await prefs.setString(_draftKey, jsonEncode(data));
}

Future<void> _restoreDraft() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_draftKey);

  if (raw == null) return;

  final data = jsonDecode(raw);

  setState(() {
    _currentStep = data["step"] ?? 0;

    nameCtrl.text = data["name"] ?? '';
    emailCtrl.text = data["email"] ?? '';
    contactCtrl.text = data["contact"] ?? '';
    emergencyCtrl.text = data["emergency"] ?? '';
    addressCtrl.text = data["city"] ?? '';
    kycNoCtrl.text = data["kycNo"] ?? '';

    selectedGender = data["gender"];
    selectedNationality = data["nationality"];
    selectedkycType = data["kycType"];
    selectedAgencyId = data["agencyId"];

    final deviceName = data["device"];
    if (deviceName != null) {
      selectedDevice = DeviceType.values
          .firstWhere((e) => e.name == deviceName);
    }

    final filePath = data["kycFilePath"];
    if (filePath != null && File(filePath).existsSync()) {
      selectedKycFile = File(filePath);
    }
  });

  // Optional UX feedback
  if (mounted) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    WarningFlash.show(
      context,
      message: "Restored your previous registration progress",
    );
  });
}

Future<void> _maybeRestoreDraft() async {
  final prefs = await SharedPreferences.getInstance();

  // If auth token exists → user is logged in
  final token = prefs.getString('token'); // OR use TokenStorage.getToken()

  if (token != null && token.isNotEmpty) {
    await _clearDraft(); // 🔥 important
    return;
  }

  await _restoreDraft(); // restore only if NOT logged in
}


}
Future<void> _clearDraft() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(_draftKey);
}

Future<void> _maybeRestoreDraft() async {
  final prefs = await SharedPreferences.getInstance();

  // If auth token exists → user is logged in
  final token = prefs.getString('token'); // OR use TokenStorage.getToken()

  if (token != null && token.isNotEmpty) {
    await _clearDraft(); // 🔥 important
    return;
  }

  await _restoreDraft(); // restore only if NOT logged in
}


  @override
  void initState() {
    super.initState();
    _maybeRestoreDraft();
    context.read<AgencyBloc>().add(LoadAgencies());
  }

  @override
  void dispose() {
    _clearDraft();
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
    _saveDraft();
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _back() {
    _saveDraft();
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
        if (state is RegisterSuccess) {
          _clearDraft();
          SuccessFlash.show(context, message: "Registration Successful ");
          Future.delayed(const Duration(seconds: 2), () {
            context.go('/login');
          });
        } else if (state is AuthError) {
          ErrorFlash.show(context, message: state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.bgDark,

          // LOGIN STYLE APP BAR
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primaryDark,
              ),
              onPressed: _back,
            ),
            title: Text(
              "New Registration",
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            centerTitle: true,
          ),

          // LOGIN STYLE BACKGROUND
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryDark.withOpacity(0.28),
                  AppColors.bgDark,
                ],
              ),
            ),
            child: SafeArea(
              child: Form(
                key: _formKey,
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
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text(
                              _steps[_currentStep].helperText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.MenuButton,
                              ),
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
                          alignment: Alignment.topCenter,
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

            // ✅ OG look + AppColors
            backgroundColor: AppColors.surfaceLight, // track
            valueColor: const AlwaysStoppedAnimation(
              AppColors.secondaryDarkMode,
              // filled progress
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "0${_currentStep + 1}/${_steps.length}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    ),
  );
}

  // ───────────────── STEP 1 ─────────────────
  // ALL STEP METHODS BELOW ARE UNCHANGED
  // (exactly as you provided)

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
          onChanged: (v) { setState(() => selectedGender = v);
        _saveDraft();},
          
        ),
        MyDropdownField<String>(
          label: "Nationality",
          hintText: "Select Nationality",
          value: selectedNationality,
          items: DropdownUtils.buildDropdownItems(Nationalities.all),
          onChanged: (v) { setState(() => selectedNationality = v);_saveDraft();},
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
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  final surface =
      isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  final primary =
      isDark ? AppColors.primaryDark : AppColors.primaryLight;
  final border =
      isDark ? AppColors.primaryDark : AppColors.primaryLight;
  final text =
      isDark ? AppColors.Light : AppColors.Dark;
  final muted =
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// ── TITLE
      Text(
        "Select Your Device Type",
        style: theme.textTheme.titleMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 12),

      /// ── MOBILE
      _DeviceOptionCard(
        title: "Mobile",
        icon: Icons.smartphone,
        selected: selectedDevice == DeviceType.mobile,
        onTap: () => setState(() {
          selectedDevice = DeviceType.mobile;
          _saveDraft();
        }),
      ),

      const SizedBox(height: 10),

      /// ── WEARABLE
      _DeviceOptionCard(
        title: "Wearable",
        icon: Icons.watch,
        selected: selectedDevice == DeviceType.device,
        onTap: () => setState(() {
  selectedDevice = DeviceType.device;
  _saveDraft();
}),

      ),
      

      const SizedBox(height: 20),

      /// ── AGENCY DROPDOWN (UNCHANGED)
      BlocBuilder<AgencyBloc, AgencyState>(
        builder: (context, state) {
          if (state is AgencyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AgencyLoaded) {
            return MyDropdownField<int>(
              label: "Select Agency",
              hintText: "Choose your agency",
              required: true,
              value: selectedAgencyId,
              items: state.agencies.map((agency) {
                return DropdownMenuItem<int>(
                  value: agency.id,
                  child: Text(agency.name),
                );
              }).toList(),
              onChanged: (v) { setState(() => selectedAgencyId = v);_saveDraft();},
              validator: (v) => v == null ? "Please select an agency" : null,
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
          onChanged: (v) { setState(() => selectedkycType = v);_saveDraft();},
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
              _saveDraft();
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
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primaryDark,
            ),
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryLight,
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


class _DeviceOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DeviceOptionCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surface =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final primary =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final text =
        isDark ? AppColors.Light : AppColors.Dark;
    final muted =
        isDark ? AppColors.textDisabledDark : AppColors.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? primary : primary.withOpacity(0.35),
            width: selected ? 2 : 1.4,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: primary.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? primary : muted,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: selected ? primary : text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


