import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseDatabase.instance.ref();

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  String? oldEmail;
  String? oldUsername;
  bool _hasChanged = false;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    loadDetails();
    _usernameController.addListener(_checkChanges);
    _emailController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final newUsername = _usernameController.text.trim();
    final newEmail = _emailController.text.trim();
    setState(() {
      _hasChanged =
          newUsername != (oldUsername ?? '') || newEmail != (oldEmail ?? '');
    });
  }

  Future<void> loadDetails() async {
    await user?.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null) {
      final snapshot = await db.child('users/${refreshedUser.uid}').get();
      final data = snapshot.value as Map?;
      setState(() {
        _usernameController.text = data?['username'] ?? '';
        _emailController.text = refreshedUser.email ?? '';
        oldUsername = data?['username'];
        oldEmail = refreshedUser.email;
      });
    }
  }

  Future<void> _updateDetails() async {
    if (!_formKey.currentState!.validate()) return;

    final newUsername = _usernameController.text.trim();
    final newEmail = _emailController.text.trim();

    if (newEmail != oldEmail) {
      _promptForPassword(newUsername, newEmail);
    } else {
      await _updateUsernameOnly(newUsername);
    }
  }

  Future<void> _updateUsernameOnly(String username) async {
    setState(() => _updating = true);
    try {
      await db.child('users/${user!.uid}').update({'username': username});
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _updating = false);
    }
  }

  void _promptForPassword(String newUsername, String newEmail) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter your password to confirm email change."),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateEmailAndUsername(
                    newEmail,
                    newUsername,
                    passwordController.text,
                  );
                },
                child: const Text("Confirm"),
              ),
            ],
          ),
    );
  }

  Future<void> _updateEmailAndUsername(
    String newEmail,
    String username,
    String password,
  ) async {
    setState(() => _updating = true);
    try {
      final cred = EmailAuthProvider.credential(
        email: oldEmail!,
        password: password,
      );
      await user!.reauthenticateWithCredential(cred);

      await db.child('users/${user!.uid}').update({'username': username});

      await user!.verifyBeforeUpdateEmail(newEmail);

      // Sign out immediately after sending email change verification
      if (context.mounted) {
        Navigator.pop(context);
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Session expired. Please log in again."),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      final msg =
          e.code == 'invalid-credential'
              ? 'Incorrect password!'
              : 'Error: ${e.message}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unexpected error: $e")));
    } finally {
      setState(() => _updating = false);
    }
  }

  void _sendResetPassword() async {
    if (user?.email != null) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Password Reset"),
                content: Text("A reset link has been sent to ${user!.email!}."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final saveColor = _hasChanged ? const Color(0xFF85A0E8) : Colors.grey;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D7), // pastel yellow
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF89BA3), // medium pink
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Color(0xFF5D2E46)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF87E86)), // pink
                  ),
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty ? "Enter username" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFF5D2E46)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF87E86)),
                  ),
                ),
                validator:
                    (val) =>
                        val == null || !val.contains('@')
                            ? "Enter valid email"
                            : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasChanged && !_updating ? _updateDetails : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: saveColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _updating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Changes"),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _sendResetPassword,
                icon: const Icon(
                  Icons.lock_reset,
                  color: Color(0xFF5D2E46),
                ), // deeper pink
                label: const Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: Color(0xFF5D2E46), // plum/dark text for contrast
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF8B4BA), // soft pink
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
