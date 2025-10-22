import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/features/auth/presentation/pages/registration.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboardfirstpage.dart';
import 'onboardingsecondpage.dart';
import 'onboardingthirdpage.dart';

class Onboardingpage extends StatefulWidget {
  const Onboardingpage({super.key});

  @override
  State<Onboardingpage> createState() => _OnboardingpageState();
}

class _OnboardingpageState extends State<Onboardingpage> {
  final PageController _controller = PageController();
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    FirstOnboardingPage(),
    SecondOnboardingPage(),
    ThirdOnboardingPage(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPageIndex == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Onboarding screens
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPageIndex = index);
            },
            itemBuilder: (context, index) => _pages[index],
          ),

          // Bottom controls
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(_pages.length - 1);
                    },
                    child: const Text("Skip"),
                  ),

                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      dotColor: AppColors.textPrimaryDark.withOpacity(0.3),
                      activeDotColor: AppColors.primaryBlue,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                      spacing: 5.0,
                    ),
                  ),

                  // Next / Done button
                  TextButton(
                    onPressed: () {
                      if (isLastPage) {
                        // TODO: Navigate to your home screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(isLastPage ? "Done" : "Next"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
