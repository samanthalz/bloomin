import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password';

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your email address.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: 'Password reset email sent. Check your inbox!',
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Something went wrong.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unexpected error occurred.');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF735276),
      appBar: AppBar(
        backgroundColor: const Color(0xFF735276),
        title: const Text('Forgot Password'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email and we’ll send you a reset link.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: Color(0xFFE7DAF5),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF837E93)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF9F7BFF)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9F7BFF),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                        : const Text(
                          'Send Reset Link',
                          style: TextStyle(
                            color: Color(0xFFF0E6FD),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
