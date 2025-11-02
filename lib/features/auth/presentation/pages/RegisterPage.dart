import 'dart:io';

import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/core/utils/dropdown_utils.dart';
import 'package:Travelon/core/utils/form_validators.dart';
import 'package:Travelon/core/utils/widgets/MyDropDown.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/core/utils/widgets/MyTextField.dart';
import 'package:Travelon/features/auth/data/models/tourist_model.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  String? selectedKycFileName;
  File? selectedKycFile;

  String? selectedGender;
  String? selectedNationality;
  String? selectedkycType;

  void _onContinue() {
    if (_currentStep < 3) {
      setState(() => _currentStep += 1);
    }
  }

  void _onCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
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

  /// list of gender
  final List<String> genderOptions = const ['Male', 'Female', 'Others'];

  // list of KYC types
  final List<String> KYCOptions = const ['Aadhar', 'Passport'];

  ///list of nationality
  final List<String> nationalityOptions = const [
    'Afghan',
    'Albanian',
    'Algerian',
    'American',
    'Andorran',
    'Angolan',
    'Antiguans',
    'Argentinean',
    'Armenian',
    'Australian',
    'Austrian',
    'Azerbaijani',
    'Bahamian',
    'Bahraini',
    'Bangladeshi',
    'Barbadian',
    'Belarusian',
    'Belgian',
    'Belizean',
    'Beninese',
    'Bhutanese',
    'Bolivian',
    'Bosnian',
    'Brazilian',
    'British',
    'Bruneian',
    'Bulgarian',
    'Burkinabe',
    'Burmese',
    'Burundian',
    'Cambodian',
    'Cameroonian',
    'Canadian',
    'Cape Verdean',
    'Central African',
    'Chadian',
    'Chilean',
    'Chinese',
    'Colombian',
    'Comoran',
    'Congolese',
    'Costa Rican',
    'Croatian',
    'Cuban',
    'Cypriot',
    'Czech',
    'Danish',
    'Djibouti',
    'Dominican',
    'Dutch',
    'Ecuadorean',
    'Egyptian',
    'Emirati',
    'Equatorial Guinean',
    'Eritrean',
    'Estonian',
    'Ethiopian',
    'Fijian',
    'Filipino',
    'Finnish',
    'French',
    'Gabonese',
    'Gambian',
    'Georgian',
    'German',
    'Ghanaian',
    'Greek',
    'Grenadian',
    'Guatemalan',
    'Guinean',
    'Guyanese',
    'Haitian',
    'Honduran',
    'Hungarian',
    'Icelander',
    'Indian',
    'Indonesian',
    'Iranian',
    'Iraqi',
    'Irish',
    'Israeli',
    'Italian',
    'Ivorian',
    'Jamaican',
    'Japanese',
    'Jordanian',
    'Kazakhstani',
    'Kenyan',
    'Kittitian and Nevisian',
    'Kuwaiti',
    'Kyrgyz',
    'Laotian',
    'Latvian',
    'Lebanese',
    'Liberian',
    'Libyan',
    'Liechtensteiner',
    'Lithuanian',
    'Luxembourger',
    'Macedonian',
    'Malagasy',
    'Malawian',
    'Malaysian',
    'Maldivian',
    'Malian',
    'Maltese',
    'Marshallese',
    'Mauritanian',
    'Mauritian',
    'Mexican',
    'Micronesian',
    'Moldovan',
    'Monacan',
    'Mongolian',
    'Moroccan',
    'Mozambican',
    'Namibian',
    'Nauruan',
    'Nepalese',
    'New Zealander',
    'Nicaraguan',
    'Nigerian',
    'Nigerien',
    'North Korean',
    'Norwegian',
    'Omani',
    'Pakistani',
    'Palauan',
    'Panamanian',
    'Papua New Guinean',
    'Paraguayan',
    'Peruvian',
    'Polish',
    'Portuguese',
    'Qatari',
    'Romanian',
    'Russian',
    'Rwandan',
    'Salvadoran',
    'Samoan',
    'San Marinese',
    'Sao Tomean',
    'Saudi',
    'Scottish',
    'Senegalese',
    'Serbian',
    'Seychellois',
    'Sierra Leonean',
    'Singaporean',
    'Slovakian',
    'Slovenian',
    'Solomon Islander',
    'Somali',
    'South African',
    'South Korean',
    'Spanish',
    'Sri Lankan',
    'Sudanese',
    'Surinamer',
    'Swazi',
    'Swedish',
    'Swiss',
    'Syrian',
    'Taiwanese',
    'Tajik',
    'Tanzanian',
    'Thai',
    'Togolese',
    'Tongan',
    'Trinidadian/Tobagonian',
    'Tunisian',
    'Turkish',
    'Tuvaluan',
    'Ugandan',
    'Ukrainian',
    'Uruguayan',
    'Uzbekistani',
    'Venezuelan',
    'Vietnamese',
    'Welsh',
    'Yemenite',
    'Zambian',
    'Zimbabwean',
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Flushbar(
            message: "Registration Successful 🎉",
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(Icons.check_circle, color: Colors.white),
          ).show(context);

          // Small delay before redirect
          Future.delayed(const Duration(seconds: 2), () {
            context.go('/login');
          });
        } else if (state is AuthError) {
          Flushbar(
            message: state.error,
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(Icons.error, color: Colors.white),
          ).show(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Stack(
            children: [
              // ✅ Main Stepper UI
              Form(
                key: _formKey,
                child: Stepper(
                  type: StepperType.horizontal,
                  elevation: 0,
                  currentStep: _currentStep,
                  onStepContinue: _onContinue,
                  onStepCancel: _onCancel,
                  steps: [
                    Step(
                      state:
                          _currentStep > 0
                              ? StepState.complete
                              : StepState.indexed,
                      title: const Text(""),
                      content: _basicInfoForm(),
                      isActive: _currentStep >= 0,
                    ),
                    Step(
                      state:
                          _currentStep > 1
                              ? StepState.complete
                              : StepState.indexed,
                      title: const Text(""),
                      content: _secondstepper(),
                      isActive: _currentStep >= 1,
                    ),
                    Step(
                      state:
                          _currentStep > 2
                              ? StepState.complete
                              : StepState.indexed,
                      title: const Text(""),
                      content: _thirdstepper(),
                      isActive: _currentStep >= 2,
                    ),
                    Step(
                      state:
                          _currentStep == 3
                              ? StepState.complete
                              : StepState.indexed,
                      title: const Text(""),
                      content: _fourthstepper(),
                      isActive: _currentStep >= 3,
                    ),
                  ],
                  controlsBuilder: _customStepperControls,
                ),
              ),

              // ✅ Loader Overlay
              if (state is AuthLoading)
                const Positioned.fill(child: Myloader()),
            ],
          ),
        );
      },
    );
  }

  Widget _basicInfoForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyTextField(
          hintText: "Enter Your Name",
          labelText: "Full Name",
          ctrl: nameCtrl,
        ),
        MyTextField(
          hintText: "Enter Your Email",
          labelText: "Email ID",
          ctrl: emailCtrl,
        ),
        MyTextField(
          hintText: "Enter Your Contact No.",
          labelText: "Contact No.",
          ctrl: contactCtrl,
        ),
        MyTextField(
          hintText: "Enter Your Emergency Contact",
          labelText: "Emergency Contact No.",
          ctrl: emergencyCtrl,
        ),
      ],
    );
  }

  Widget _secondstepper() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyDropdown(
          hintText: "Select Gender",
          labelText: "Gender",
          items: DropdownUtils.buildDropdownItems(genderOptions),
          value: selectedGender,
          onChanged: (newValue) {
            setState(() {
              selectedGender = newValue;
            });
          },
        ),
        MyDropdown(
          hintText: "Select Nationality",
          labelText: "Nationality",
          items: DropdownUtils.buildDropdownItems(nationalityOptions),
          value: selectedNationality,
          onChanged: (newValue) {
            setState(() {
              selectedNationality = newValue;
            });
          },
        ),
        MyTextField(
          hintText: "Enter Your Address",
          labelText: "Address",
          ctrl: addressCtrl,
        ),
        MyTextField(
          hintText: "Enter Your Agency ID",
          labelText: "Agency ID",
          ctrl: agencyCtrl,
        ),
      ],
    );
  }

  Widget _thirdstepper() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyDropdown(
          hintText: "Select KYC Type",
          labelText: "KYC Type",
          items: DropdownUtils.buildDropdownItems(KYCOptions),
          value: selectedkycType,
          onChanged: (newValue) {
            setState(() {
              selectedkycType = newValue;
            });
          },
        ),
        MyTextField(
          hintText: "Enter KYC No.",
          labelText: "KYC NO.",
          ctrl: kycNoCtrl,
        ),
        const SizedBox(height: 16),
        _kycFilePicker(),
      ],
    );
  }

  Widget _fourthstepper() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyTextField(
          hintText: "Enter Password",
          labelText: "Password",
          ctrl: passCtrl,
          obscure: true,
          validator: FormValidators.password,
        ),

        MyTextField(
          hintText: "Enter Confirm Password",
          labelText: "Confirm Password",
          ctrl: confirmPassCtrl,
          obscure: true,
          validator: (v) => FormValidators.confirmPassword(v, passCtrl.text),
        ),
      ],
    );
  }

  Widget _customStepperControls(BuildContext context, ControlsDetails details) {
    final isLastStep = _currentStep == 3;
    final authBloc = context.read<AuthBloc>();

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        children: [
          // Back Button (optional)
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: details.onStepCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Back", style: TextStyle(fontSize: 16)),
              ),
            ),

          if (_currentStep > 0) const SizedBox(width: 16), // spacing
          // Next / Finish Button
          Expanded(
            flex: 2, // slightly larger button
            child: Myelevatedbutton(
              show_text: isLastStep ? "Finish" : "Next",
              onPressed: () {
                if (isLastStep) {
                  authBloc.add(
                    RegisterEvent(_buildTouristModel(), selectedKycFile!),
                  );
                } else {
                  // Go to next step
                  details.onStepContinue?.call();
                }
              },
              width: double.infinity,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }

  // file picker ui

  Widget _kycFilePicker() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
        );

        if (result != null && result.files.single.path != null) {
          setState(() {
            selectedKycFile = File(
              result.files.single.path!,
            ); // ✅ store as File
            selectedKycFileName =
                selectedKycFile!.path.split('/').last; // show name
          });
        }
      },
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.dividerGrey.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.upload_file, color: AppColors.primaryBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedKycFileName ?? "Upload KYC Document (PNG / JPG / PDF)",
                style: TextStyle(
                  color:
                      selectedKycFileName == null
                          ? AppColors.textSecondaryGrey
                          : AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TouristModel _buildTouristModel() {
    return TouristModel(
      name: nameCtrl.text.trim(),
      nationality: selectedNationality ?? '',
      contact: contactCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      gender: selectedGender ?? '',
      kycType: selectedkycType ?? '',
      emergencyContact: emergencyCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      password: passCtrl.text.trim(),
      agencyId: int.tryParse(agencyCtrl.text.trim()) ?? 0,
      kycNo: kycNoCtrl.text.trim(),
    );
  }
}
