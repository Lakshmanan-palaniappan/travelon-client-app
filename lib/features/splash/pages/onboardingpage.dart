import 'package:Travelon/core/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final List<Widget> _pages = const [
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPageIndex = index);
                  },
                  itemBuilder: (context, index) => _pages[index],
                ),

                // Bottom controls
                Positioned(
                  bottom: constraints.maxHeight * 0.05,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip button
                        TextButton(
                          onPressed: () {
                            _controller.jumpToPage(_pages.length - 1);
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                        ),

                        // Page indicator
                        Flexible(
                          child: SmoothPageIndicator(
                            controller: _controller,
                            count: _pages.length,
                            effect: ExpandingDotsEffect(
                              dotColor: AppColors.textPrimaryDark.withOpacity(0.3),
                              activeDotColor: AppColors.primaryBlue,
                              dotHeight: size.height * 0.01,
                              dotWidth: size.height * 0.01,
                              expansionFactor: 4,
                              spacing: 5.0,
                            ),
                          ),
                        ),

                        // Next / Done button
                        TextButton(
                          onPressed: () async {
                            if (isLastPage) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('onboarding_done', true);
                              context.go('/landingpage'); // or '/login'
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            isLastPage ? "Done" : "Next",
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
