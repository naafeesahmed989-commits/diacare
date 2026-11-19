import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  
  static const _gradientStart = Color(0xFF62FFDA);
  static const _gradientEnd = Color(0xFF4554FF);
  static const _blue = Color(0xFF006BFA);

  void _openSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  void _openSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Layer 1: gradient over the whole screen.
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_gradientStart, _gradientEnd],
                  ),
                ),
              ),
            ),

            // Layer 2: white card. 
            Positioned(
              top: 339,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
              ),
            ),

            // Logo. 
            Positioned(
              top: 91,
              left: 0,
              right: 0,
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/diacare_logo.png',
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Title
            Positioned(
              top: 185, 
              left: 0,
              right: 0,
              child: Text(
                'Welcome to DiaCare',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  height: 1.4, 
                  color: Colors.black,
                ),
              ),
            ),

            // Description. 
            Positioned(
              top: 244, 
              left: 32, 
              right: 32,
              child: Text(
                'Manage your diabetes care easily with '
                'reminders, tracking, and health insights.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 22 / 16,
                  letterSpacing: 0.16, 
                  color: const Color(0xFF222222),
                ),
              ),
            ),

            // Button 1: Continue with google.
            Positioned(
              top: 430,
              left: 40,
              right: 40,
              child: _AuthButton(
                label: 'Continue with google',
                icon: SizedBox(
                  width: 26,
                  height: 26,
                  child: Image.asset(
                    'assets/images/google_logo.png',
                    // If the file is missing, show a simple icon instead.
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.g_mobiledata, size: 26),
                  ),
                ),
                backgroundColor: const Color(0x99006BFA), 
                textColor: Colors.white,
                onPressed: () {
                  // New user -> Sign up. Existing user -> Home.
                  _openSignUp(context);
                },
              ),
            ),

            // Button 2: Continue with email.
            Positioned(
              top: 522,
              left: 40,
              right: 40,
              child: _AuthButton(
                label: 'Continue with email',
                icon: const Icon(
                  Icons.mail_outline,
                  size: 24,
                  color: Colors.black,
                ),
                backgroundColor: const Color(0xFFEEEEEE),
                textColor: const Color(0xFF333333),
                onPressed: () => _openSignIn(context),
              ),
            ),

            // Bottom line: "New here, Create an account".
            Positioned(
              left: 0,
              right: 0,
              bottom: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New here, ',
                    style: GoogleFonts.poppins(
                      fontSize: 13, 
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openSignUp(context),
                    child: Text(
                      'Create an account',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _blue,
                        decoration: TextDecoration.underline,
                        decorationColor: _blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // icon + text centered
          children: [
            icon,
            const SizedBox(width: 24),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 18, 
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}