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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF735276),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70, bottom: 50),
            child: Center(
              child: Image.asset(
                "assets/img/Bloomin_logo.png",
                width: 350,
                fit: BoxFit.contain,
              ),
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
                TextField(
                  controller: _emailController,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Color(0xFFE7DAF5),
                    labelStyle: TextStyle(
                      color: Color(0xFF29264C),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF837E93),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF9F7BFF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _passController,
                  obscureText: _obscurePassword,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: const Color(0xFFE7DAF5),
                    labelStyle: const TextStyle(
                      color: Color(0xFF29264C),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF837E93),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF9F7BFF),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF735276),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: SizedBox(
                    width: 329,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _emailController.text.trim();
                        final password = _passController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please fill in all fields",
                          );
                          return;
                        }

                        try {
                          final auth = FirebaseAuth.instance;
                          final UserCredential userCredential = await auth
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          final user = userCredential.user;

                          if (user != null && user.emailVerified) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                                  (Route<dynamic> route) => false,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg:
                              "Email not verified. A verification link has been sent.",
                            );
                            await user?.sendEmailVerification();
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-credential') {
                            Fluttertoast.showToast(
                              msg:
                              "Invalid email or password. Please try again.",
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Login failed: ${e.message}",
                            );
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: "An error occurred. Please try again.",
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9F7BFF),
                      ),
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
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Don’t have an account?',
                      style: TextStyle(
                        color: Color(0xFFAB95CA),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 2.5),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignupPage(controller: widget.controller),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF846BD6),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ForgotPasswordPage.routeName);
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF846BD6),
                      fontSize: 15,
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
}
