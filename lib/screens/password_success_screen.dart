import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_widgets.dart';
import 'sign_in_screen.dart';

class PasswordSuccessScreen extends StatelessWidget {
  const PasswordSuccessScreen({super.key});

  void _goToSignIn(BuildContext context) {
    // Remove the reset screens. We keep only the first screen (Welcome),
    // so Back from Sign in goes to Welcome.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
      (route) => route.isFirst,
    );
  }

  // One round shape. The three circles and the icon are built from these.
  Widget _circle(double size, Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: SizedBox(width: size, height: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PopScope(canPop: false) blocks the Back button here,
    // so the user leaves with the "Sign in" button only.
    return PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // The circles group.
              Positioned(
                top: 125,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 326,
                    height: 326,
                    child: Stack(
                      children: [
                        
                        Positioned.fill(
                          child: _circle(326, const Color(0xFFF3FFFD)),
                        ),
                        
                        Positioned(
                          left: 69.39,
                          top: 63.88,
                          child: _circle(187.23, const Color(0xFFD8FAF4)),
                        ),
                        
                        
                        Positioned(
                          left: 85.36,
                          top: 79.85,
                          child: _circle(155.29, const Color(0xFFE5FEFA)),
                        ),
                        
                      
                        Positioned(
                          left: 103,
                          top: 97.5,
                          child: Image.asset(
                            'assets/images/confetti_ball.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            // If the file is missing, show a simple icon.
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(
                              width: 120,
                              height: 120,
                              child: Icon(
                                Icons.celebration,
                                size: 80,
                                color: Color(0xFFFFC107),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              
              Positioned(
                top: 542, 
                left: 24,
                right: 24,
                child: Text(
                  'Password Reset Successful',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),

              // Description 
              Positioned(
                top: 580, 
                left: 24,
                right: 24,
                child: Text(
                  'Password has been successfully reset.\n'
                  'Sign in with your new password',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 17 / 13,
                    color: const Color(0xFF666666),
                  ),
                ),
              ),

              // Sign in button. 
              Positioned(
                left: 40,
                right: 40,
                bottom: 51,
                child: AuthButton(
                  label: 'Sign in',
                  backgroundColor: const Color(0xFF006BFA),
                  textColor: Colors.white,
                  fontSize: 20, 
                  fontWeight: FontWeight.w500,
                  onPressed: () => _goToSignIn(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}