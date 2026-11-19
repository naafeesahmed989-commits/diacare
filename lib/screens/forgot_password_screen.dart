import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_widgets.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your email';
    final looksLikeEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    if (!looksLikeEmail) return 'Please enter a valid email';
    return null;
  }

  void _sendLink() {
    if (!_formKey.currentState!.validate()) return;

    // opens the link from the email. For now we go straight to the next screen.
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showLogo: false, // no logo
      topBarTitle: 'Forgot Password',
      description:
          'Enter your email address and we’ll send you a link to reset your password.',
      descriptionTop: 229, 
      descriptionSidePadding: 41,
      descriptionStyle: GoogleFonts.poppins(
        fontSize: 18, 
        fontWeight: FontWeight.w500,
        height: 22 / 18,
        color: const Color(0xFF3C3C3C),
      ),
      cardTopPadding: 65, 
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: TextFormField(
                controller: _emailController,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _sendLink(),
                style: authInputStyle(),
                decoration: authFieldDecoration(hint: 'Email'),
              ),
            ),
            const SizedBox(height: 59), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AuthButton(
                label: 'Send Reset link',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 20, 
                fontWeight: FontWeight.w500,
                onPressed: _sendLink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}