import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  static const _blue = Color(0xFF006BFA);

  @override
  Widget build(BuildContext context) {
    // Height of the phone's status bar (time, battery...). We use it to
    // place "Skip" just below it, because the photo now goes behind it.
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Make the status bar see-through, with dark icons (the photo is light).
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        // No SafeArea here: the photo must reach the very top.
        body: Stack(
          children: [
            // Layer 1: the photo, covering the whole screen.
            Positioned.fill(
              child: Image.asset(
                'assets/images/onboarding_one.jpeg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // Layer 2: "Skip", on top of the photo.
            Positioned(
              // Figma: Y 32. max() keeps it below the status bar on phones
              // that have a taller status bar.
              top: math.max(32, statusBarHeight + 8),
              // Figma: X 353 on a 402 wide frame, so about 20 from the right.
              right: 20,
              child: GestureDetector(
                onTap: () {
                  // We will add navigation later.
                },
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

            // Layer 3: the white card, stuck to the bottom.
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
                // Inside the card we use a second Stack, so each item
                // sits at the same distance from the card's top as in Figma.
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Title + description (Figma: X 45, Y 48, gap 12)
                    Positioned(
                      top: 48,
                      left: 45,
                      right: 45,
                      child: Column(
                        children: [
                          Text(
                            'Manage Diabetes Easily',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 1.4, // 140%
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Track your glucose levels, medications, '
                            'and daily health habits in one simple place.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 21.1 / 16, // line height / font size
                              color: const Color(0xFF5D5D5D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Next button (Figma: 288 x 58)
                    Positioned(
                      top: 171, 
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 288,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              // We will add navigation later.
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const StadiumBorder(), // pill shape
                            ),
                            child: Text(
                              'Next',
                              style: GoogleFonts.poppins(
                                fontSize: 16, 
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Page dots (Figma: Y 253, centered)
                    const Positioned(
                      top: 253,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: PageDots(count: 3, activeIndex: 2),
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

/// Small dots under the button. The other onboarding screens
/// can reuse it by changing only [activeIndex].
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.activeIndex});

  final int count; // how many dots
  final int activeIndex; // which one is blue (0 = first)

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5.69, // Figma: (29.38 total - 3 dots x 6) / 2 gaps
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