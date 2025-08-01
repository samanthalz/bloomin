import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'otp_page.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signup';
  final PageController controller;

  const SignupPage({super.key, required this.controller});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();

  bool _obscurePass = true;
  bool _obscureRepass = true;

  Future<void> _validateAndProceed(BuildContext context) async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passController.text.trim();
    final repass = _repassController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || repass.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill in all fields");
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(msg: "Invalid email format");
      return;
    }

    if (password.length < 8) {
      Fluttertoast.showToast(msg: "Password must be at least 8 characters");
      return;
    }

    if (password != repass) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    try {
      final auth = FirebaseAuth.instance;
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();

        final dbRef = FirebaseDatabase.instance.ref().child('users').child(user.uid);
        await dbRef.set({
          'username': username,
          'email': email,
          'uid': user.uid,
          'created_at': DateTime.now().toIso8601String(),
        });

        Fluttertoast.showToast(msg: "Verification email sent to $email");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpPage(email: email)),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Signup failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFBEBE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            Center(
              child: Image.asset(
                "assets/img/Bloomin_logo.png",
                width: 350,
                fit: BoxFit.contain,
                color: const Color(0xFFD85C84),
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
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xFF29264C),
                      fontSize: 27,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(_usernameController, 'Username'),
                  const SizedBox(height: 17),
                  _buildInputField(_emailController, 'Email'),
                  const SizedBox(height: 17),
                  _buildPasswordField(_passController, 'Create Password', true),
                  const SizedBox(height: 17),
                  _buildPasswordField(_repassController, 'Confirm Password', false),
                  const SizedBox(height: 25),
                  _buildCreateAccountButton(),
                  const SizedBox(height: 15),
                  _buildLoginLink(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFFFF4D7),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF837E93)),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFF4DA6), width: 2), // bright pink
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 15,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      decoration: _fieldDecoration(label),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool isPass) {
    return TextField(
      controller: controller,
      obscureText: isPass ? _obscurePass : _obscureRepass,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 15,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      decoration: _fieldDecoration(label).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            isPass
                ? (_obscurePass ? Icons.visibility_off : Icons.visibility)
                : (_obscureRepass ? Icons.visibility_off : Icons.visibility),
          ),
          onPressed: () {
            setState(() {
              if (isPass) {
                _obscurePass = !_obscurePass;
              } else {
                _obscureRepass = !_obscureRepass;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: SizedBox(
        width: 329,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            _validateAndProceed(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9F7BFF),
          ),
          child: const Text(
            'Create Account',
            style: TextStyle(
              color: Color(0xFFF0E6FD),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Have an account?',
          style: TextStyle(
            color: Color(0xFFAB95CA),
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text(
            'Log In',
            style: TextStyle(
              color: Color(0xFF846BD6),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
