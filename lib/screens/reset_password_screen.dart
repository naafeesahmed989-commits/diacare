import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_widgets.dart';
import 'password_success_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateNew(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a new password';
    if (value.length < 8) return 'Password must contain at least 8 characters';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    // The second password must be the same as the first one.
    if (value != _newController.text) return 'Passwords do not match';
    return null;
  }

  void _reset() {
    if (!_formKey.currentState!.validate()) return;

    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PasswordSuccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.poppins(
      fontSize: 16, 
      fontWeight: FontWeight.w500,
      height: 24 / 16,
      color: Colors.black,
    );

    return AuthScaffold(
      showLogo: false,
      topBarTitle: 'Reset Password',
      description: 'Create a new password for your account.',
      descriptionTop: 231, 
      descriptionSidePadding: 71,
      descriptionStyle: GoogleFonts.poppins(
        fontSize: 18, 
        fontWeight: FontWeight.w500,
        height: 1.0, 
        color: const Color(0xFF3C3C3C),
      ),
      // Reset password button
      bottomChild: AuthButton(
        label: 'Reset Password',
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 20, 
        fontWeight: FontWeight.w500,
        onPressed: _reset,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Text('New Password', style: labelStyle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: PasswordField(
                controller: _newController,
                validator: _validateNew,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 19),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Text('Confirm Password', style: labelStyle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: PasswordField(
                controller: _confirmController,
                validator: _validateConfirm,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _reset(),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Text(
                
                'Password must contain at least 8 characters .',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  height: 18 / 12,
                  color: const Color(0xFF8A8A8A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}