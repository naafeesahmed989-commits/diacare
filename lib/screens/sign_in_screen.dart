import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_widgets.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // The key lets us ask the form: "are all the fields correct?"
  final _formKey = GlobalKey<FormState>();

  // Controllers give us the text the user typed.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hidePassword = true; 

  static const _blue = Color(0xFF006BFA);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // A validator returns a message when something is wrong,
  // or null when the field is fine.
  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your email';
    final looksLikeEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    if (!looksLikeEmail) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void _signIn() {
    // Stop here if any field shows an error.
    if (!_formKey.currentState!.validate()) return;

    // pushAndRemoveUntil clears the old screens, so Back doesn't return here.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _openSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  
  InputDecoration _fieldDecoration({required String hint, Widget? suffix}) {
    const noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide.none,
    );
    const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE53935)),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: const Color(0xFF8A8A8A),
      ),
      errorStyle: GoogleFonts.poppins(fontSize: 12),
      filled: true,
      fillColor: const Color(0xFFF8F8F8),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      suffixIcon: suffix,
      border: noBorder,
      enabledBorder: noBorder,
      focusedBorder: noBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = GoogleFonts.poppins(
      fontSize: 14,
      color: const Color(0xFF555555),
    );

    return AuthScaffold(
      title: 'Welcome Back',
      description: 'Sign in to continue managing your diabetes care.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email field. 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: TextFormField(
                controller: _emailController,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: inputStyle,
                decoration: _fieldDecoration(hint: 'Email'),
              ),
            ),
            const SizedBox(height: 14),

            // Password field, with the eye icon.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: TextFormField(
                controller: _passwordController,
                validator: _validatePassword,
                obscureText: _hidePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _signIn(),
                style: inputStyle,
                decoration: _fieldDecoration(
                  hint: 'Password',
                  suffix: IconButton(
                    onPressed: () =>
                        setState(() => _hidePassword = !_hidePassword),
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9),

            // "Forgot password" link.
            Padding(
              padding: const EdgeInsets.only(left: 39),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _openForgotPassword,
                  child: Text(
                    'Forgot password',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF3B8BFF),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 23),

            // Sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AuthButton(
                label: 'Sign in',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 20, 
                fontWeight: FontWeight.w500,
                onPressed: _signIn,
              ),
            ),
            const SizedBox(height: 45),

            // "—— or ——"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 33, height: 1, color: const Color(0xFFBDBDBD)),
                const SizedBox(width: 11),
                Text('or', style: GoogleFonts.poppins(fontSize: 16)),
                const SizedBox(width: 11),
                Container(width: 33, height: 1, color: const Color(0xFFBDBDBD)),
              ],
            ),
            const SizedBox(height: 47),

            // Continue with google
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AuthButton(
                label: 'Continue with google',
                backgroundColor: const Color(0x99006BFA), 
                textColor: Colors.white,
                icon: SizedBox(
                  width: 26,
                  height: 26,
                  child: Image.asset(
                    'assets/images/google_logo.png',
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.g_mobiledata, size: 26),
                  ),
                ),
                onPressed: () {
                  
                  // New user -> Sign up. Existing user -> Home.
                  _openSignUp();
                },
              ),
            ),
            const SizedBox(height: 17),

            // "New here, Create an account"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New here, ',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                GestureDetector(
                  onTap: _openSignUp,
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
          ],
        ),
      ),
    );
  }
}