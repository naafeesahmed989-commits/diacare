import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'welcome_screen.dart';

/// The text and photo of ONE onboarding page:

class OnboardingData {
  const OnboardingData({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  final String image;
  final String title;
  final String description;
  final String buttonText;
}

/// Holds the 3 pages and switches between them.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0; // the page we are on now (0, 1 or 2)

  static const _pages = [
    OnboardingData(
      image: 'assets/images/onboarding_one.jpeg',
      title: 'Manage Diabetes Easily',
      description: 'Track your glucose levels, medications, '
          'and daily health habits in one simple place.',
      buttonText: 'Next',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_two.png',
      title: 'Never Miss a dose',
      description: 'Receive timely reminders for your insulin '
          'and medications every day.',
      buttonText: 'Next',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_three.png',
      title: 'Track your progress',
      description: 'Track your glucose readings, view your progress, '
          'and understand your health trends easily.',
      buttonText: 'Get Started',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose(); // free the controller when the screen closes
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToWelcome(); // last page: "Get Started"
    }
  }

  void _skip() => _goToWelcome();

  // pushReplacement removes the onboarding, so Back doesn't return to it.
  void _goToWelcome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: _pages.length,
      onPageChanged: (index) => setState(() => _page = index),
      itemBuilder: (context, index) {
        return OnboardingPage(
          data: _pages[index],
          activeDot: _pages.length - 1 - index,
          onNext: _next,
          onSkip: _skip,
        );
      },
    );
  }
}

/// One onboarding screen. The layout is the same for all pages.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.data,
    required this.activeDot,
    required this.onNext,
    required this.onSkip,
  });

  final OnboardingData data;
  final int activeDot;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  static const _blue = Color(0xFF006BFA);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Layer 1: the photo, covering the whole screen.
            Positioned.fill(
              child: Image.asset(
                data.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // Layer 2: "Skip".
            Positioned(
              top: math.max(32, statusBarHeight + 8),
              right: 20,
              child: GestureDetector(
                onTap: onSkip,
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 17.6 / 16,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            // Layer 3: the white card at the bottom.
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 348,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Title + description
                    Positioned(
                      top: 48,
                      left: 45,
                      right: 45,
                      child: Column(
                        children: [
                          Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 21.1 / 16,
                              color: const Color(0xFF5D5D5D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Button
                    Positioned(
                      top: 171, 
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 288,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              data.buttonText,
                              style: GoogleFonts.poppins(
                                fontSize: 16, 
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Dots
                    Positioned(
                      top: 253,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: PageDots(count: 3, activeIndex: activeDot),
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

/// Small dots under the button.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.activeIndex});

  final int count; // how many dots
  final int activeIndex; // which one is blue (0 = left)

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5.69,
      children: List.generate(count, (i) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == activeIndex
                ? const Color(0xFF006BFA)
                : const Color(0xFFD9D9D9),
          ),
        );
      }),
    );
  }
}