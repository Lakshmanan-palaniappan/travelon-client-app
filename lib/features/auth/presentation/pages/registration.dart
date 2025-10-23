import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/core/utils/appimageassets.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedGender;
  String? selectedKyctype;
  String? selectedNatioanlity;
  final List<String> _gender = ['Male', 'Female', 'Others'];
  final List<String> _kyc_types = ['Aadhar', 'Password'];
  final List<String> _nationality = [
    'Indian',
    'American',
    'British',
    'Canadian',
    'Australian',
    'Chinese',
    'Japanese',
    'German',
    'French',
    'Italian',
    'Russian',
    'Brazilian',
    'South African',
    'Mexican',
    'Spanish',
    'Indonesian',
    'Turkish',
    'Saudi Arabian',
    'Thai',
    'Vietnamese',
    'Korean',
    'Argentinian',
    'Egyptian',
    'Nigerian',
    'Bangladeshi',
    'Pakistani',
    'Sri Lankan',
    'Nepali',
    'Malaysian',
    'Singaporean',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backgroundLight,
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            verticalDirection: VerticalDirection.down,
            children: [
              // Registration LottieImage
              Lottie.asset(
                AppImageAssets().register_lottie,
                width: 250,
                height: 250,
              ),
              Text(
                "Let’s get you set up! A few quick details and you’re ready to travel.",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),

              // Registration  Text Fields
              Column(
                children: [
                  Mytextfield(hint_text: "Enter Name", label_text: "Name"),
                  Mytextfield(hint_text: "Enter Email", label_text: "Email"),
                  // Mytextfield(
                  //   hint_text: "Enter Your Phone Number",
                  //   label_text: "Contact No.",
                  // ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    value: selectedGender,
                    items:
                        _gender.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                    validator:
                        (value) =>
                            value == null ? 'Please select a Gender' : null,
                  ),
                ],
              ),
              // Next Button
              Myelevatedbutton(show_text: "Next", onPressed: () {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have an Account?"),
                  RichText(
                    text: TextSpan(
                      text: "Sign In",
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
              // Bottom Text
              Text(
                "By continuing, you agree to our Terms of Service, Privacy Policy, and Cancellation & Refund Policy.",
                style: TextStyle(fontSize: 10.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
