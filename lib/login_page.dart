import 'package:bloomin/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  final PageController controller;
  const LoginPage({super.key, required this.controller});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;

  /// helper to create consistent borders
  OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFBEBE), // soft pink background
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          Center(
            child: Image.asset(
              'assets/img/Bloomin_logo.png',
              width: 350,
              fit: BoxFit.contain,
              color: const Color(0xFFD85C84),           // pink tint
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Log In',
                  style: TextStyle(
                    color: Color(0xFF29264C),
                    fontSize: 27,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),

                // ── Email Field ────────────────────────────────────────
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: const Color(0xFFFFF4D7),           // yellow
                    enabledBorder: _border(const Color(0xFF837E93)),
                    focusedBorder: _border(const Color(0xFFFF4DA6), 2), // bright pink border
                  ),
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 30),

                // ── Password Field ────────────────────────────────────
                TextField(
                  controller: _pass,
                  obscureText: _hide,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: const Color(0xFFFFF4D7),
                    enabledBorder: _border(const Color(0xFF837E93)),
                    focusedBorder: _border(const Color(0xFFFF4DA6), 2),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hide ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF5D2E46),
                      ),
                      onPressed: () => setState(() => _hide = !_hide),
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 25),

                // ── Log In Button ─────────────────────────────────────
                SizedBox(
                  width: 329,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9F7BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _login,
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Color(0xFFF0E6FD),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // ── Sign‑Up Link ──────────────────────────────────────
                Row(
                  children: [
                    const Text(
                      'Don’t have an account?',
                      style: TextStyle(
                        color: Color(0xFFAB95CA),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SignupPage(controller: widget.controller),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF846BD6),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // ── Forgot Password ───────────────────────────────────
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, ForgotPasswordPage.routeName),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF846BD6),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // login handler
  Future<void> _login() async {
    final email = _email.text.trim();
    final pwd = _pass.text.trim();

    if (email.isEmpty || pwd.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all fields');
      return;
    }

    try {
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);

      if (cred.user != null && cred.user!.emailVerified) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        }
      } else {
        Fluttertoast.showToast(msg: 'Verify your email first!');
        await cred.user?.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Login failed');
    }
  }
}
