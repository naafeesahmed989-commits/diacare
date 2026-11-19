import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Colours
  static const Color _gradientStart = Color(0xFF62FFDA);
  static const Color _gradientEnd = Color(0xFF4554FF);

  Timer? _timer;

  
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return; // do nothing if the screen is already gone
      // pushReplacement removes the splash, so Back doesn't return to it.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _gradientStart,
              _gradientEnd,
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 5),
            ClipOval(
              child: Image.asset(
                'assets/images/diacare_logo.png',
                width: 116,
                height: 116,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'DiaCare AI',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                height: 1.5,
                letterSpacing: -0.32,
                color: Colors.white,
              ),
            ),
            const Spacer(flex: 6),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 56 + bottomInset),
              child: Text(
                'Manage Diabetes with confidence',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 17.6 / 16,
                  letterSpacing: 0.16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}