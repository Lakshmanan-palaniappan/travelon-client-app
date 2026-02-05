import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:Travelon/features/splash/pages/onboardfirstpage.dart';
import 'package:Travelon/features/splash/pages/onboardingsecondpage.dart';
import 'package:Travelon/features/splash/pages/onboardingthirdpage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool isLastPage = _currentPageIndex == _pages.length - 1;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            /// --- Pages ---
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => _currentPageIndex = index);
              },
              itemBuilder: (context, index) => _pages[index],
            ),

            /// --- Bottom Controls ---
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Skip
                    TextButton(
                      onPressed: () {
                        _controller.jumpToPage(_pages.length - 1);
                      },
                      child: Text(
                        "Skip",
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.titleLarge?.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    /// Indicator
                    SmoothPageIndicator(
                      controller: _controller,
                      count: _pages.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 6,
                        expansionFactor: 4,
                        dotColor: colors.onBackground.withOpacity(0.3),
                        activeDotColor: AppColors.success,
                      ),
                    ),

                    /// Next / Done
                    TextButton(
                      onPressed: () async {
                        if (isLastPage) {
                          final prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('onboarding_done', true);
                          context.go('/landingpage');
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        isLastPage ? "Done" : "Next",
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.brightness==Brightness.dark?theme.colorScheme.secondary:theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
