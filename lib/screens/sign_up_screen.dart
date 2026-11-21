import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_widgets.dart';
import 'home_screen.dart';
import 'placeholder_screens.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // A recognizer makes one part of a text tappable (our two links).
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  static const _blue = Color(0xFF006BFA);
  static const _linkColor = Color(0xFF2A7FB0); 

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()
      ..onTap = () => _open(const TermsOfServiceScreen());
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => _open(const PrivacyPolicyScreen());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your email';
    final looksLikeEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    if (!looksLikeEmail) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 8) return 'Password must contain at least 8 characters';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;

    
    // pushAndRemoveUntil clears the old screens, so Back doesn't return here.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _goToSignIn() {
    // Keep only the first screen (Welcome), then show Sign in.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
      (route) => route.isFirst,
    );
  }

  // The label above each field.
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16, 
          fontWeight: FontWeight.w500,
          height: 26 / 16, 
          color: Colors.black,
        ),
      ),
    );
  }

  // Puts the same side space around a field.
  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = TextStyle(
      color: _linkColor,
      decoration: TextDecoration.underline,
      decorationColor: _linkColor,
    );

    return AuthScaffold(
      topBarTitle: 'Create an account',
      logoTop: 123, 
      
      gradientColors: const [Color(0xFFDFF3FC), Color(0xFFFBFEFF)],
      description:
          'Create an account to start managing your diabetes with DiaCare.',
      descriptionTop: 241,
      descriptionSidePadding: 41,
      descriptionStyle: GoogleFonts.poppins(
        fontSize: 18, 
        fontWeight: FontWeight.w500,
        height: 22 / 18,
        color: const Color(0xFF3C3C3C),
      ),
      cardTopPadding: 27, 
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _label('Full Name'),
            _padded(
              TextFormField(
                controller: _nameController,
                validator: _validateName,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                style: authInputStyle(),
                decoration: authFieldDecoration(hint: 'Full name'),
              ),
            ),
            _label('Email Address'),
            _padded(
              TextFormField(
                controller: _emailController,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: authInputStyle(),
                decoration: authFieldDecoration(hint: 'Email'),
              ),
            ),
            _label('New Password'),
            _padded(
              PasswordField(
                controller: _passwordController,
                validator: _validatePassword,
                textInputAction: TextInputAction.next,
              ),
            ),
            _label('Confirm Password'),
            _padded(
              PasswordField(
                controller: _confirmController,
                validator: _validateConfirm,
                hint: 'Confirm password',
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _createAccount(),
              ),
            ),
            const SizedBox(height: 7),

            // "By creating an account, you agree to our Terms of Service and
            // Privacy policy". The two links open placeholder screens for now.
            _padded(
              Text.rich(
                TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 11, 
                    height: 16 / 11,
                    color: const Color(0xFF8A8A8A),
                  ),
                  children: [
                    const TextSpan(
                      text: 'By creating an account, you agree to our\n',
                    ),
                    TextSpan(
                      text: 'Terms of Service',
                      style: linkStyle,
                      recognizer: _termsTap,
                    ),
                    const TextSpan(
                      text: ' and ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Privacy policy',
                      style: linkStyle,
                      recognizer: _privacyTap,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AuthButton(
                label: 'Create an account',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 20, 
                fontWeight: FontWeight.w500,
                onPressed: _createAccount,
              ),
            ),
            const SizedBox(height: 7),

            // "Already have an account, Sign in"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account, ',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                GestureDetector(
                  onTap: _goToSignIn,
                  child: Text(
                    'Sign in',
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
          ],
        ),
      ),
    );
  }
}