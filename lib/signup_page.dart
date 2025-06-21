import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF735276),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Padding(
              padding: const EdgeInsets.only(top: 70, bottom: 10),
              child:Center(
                child: Image.asset(
                  "assets/img/Bloomin_logo.png",
                  width: 350,
                  fit: BoxFit.contain,
                ),
              )
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

                  // Username
                  TextField(
                    controller: _usernameController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Color(0xFFE7DAF5),
                      labelStyle: TextStyle(
                        color: Color(0xFF786B89),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF837E93)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF9F7BFF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),

                  // Email
                  TextField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Color(0xFFE7DAF5),
                      labelStyle: TextStyle(
                        color: Color(0xFF786B89),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF837E93)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF9F7BFF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),

                  // Password
                  TextField(
                    controller: _passController,
                    obscureText: _obscurePass,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Create Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePass
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePass = !_obscurePass;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Color(0xFFE7DAF5),
                      labelStyle: TextStyle(
                        color: Color(0xFF786B89),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF837E93)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF9F7BFF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),

                  // Confirm Password
                  TextField(
                    controller: _repassController,
                    obscureText: _obscureRepass,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureRepass
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureRepass = !_obscureRepass;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Color(0xFFE7DAF5),
                      labelStyle: TextStyle(
                        color: Color(0xFF786B89),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF837E93)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Color(0xFF9F7BFF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Create Account Button
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 329,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.controller.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9F7BFF),
                        ),
                        child: const Text(
                          'Create account',
                          style: TextStyle(
                            color: Color(0xFFE5D0FF),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Log in link
                  Row(
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
                          widget.controller.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
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
