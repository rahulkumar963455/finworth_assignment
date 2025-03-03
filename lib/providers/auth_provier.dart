import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for Sign-Up
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailControllerS = TextEditingController();
  final TextEditingController passwordControllerS = TextEditingController();
  final TextEditingController confirmPasswordControllerS = TextEditingController();

  // Controllers for Sign-In
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form Keys
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  // ✅ Loading State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// **Sign Up Method (Firebase)**
  Future<bool> signUp(BuildContext context) async {
    if (!signUpFormKey.currentState!.validate()) {
      return false;
    }

    String email = emailControllerS.text.trim();
    String password = passwordControllerS.text.trim();

    setLoading(true); // ✅ Start loading
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully!")),
      );

      _clearSignUpFields();
      return true;
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(context, e.message ?? "An error occurred.");
      return false;
    } finally {
      setLoading(false); // ✅ Stop loading
    }
  }

  /// **Sign In Method (Firebase)**
  Future<bool> signIn(BuildContext context) async {
    if (!signInFormKey.currentState!.validate()) return false;

    setLoading(true); // ✅ Start loading
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signed in successfully!")),
      );

      _clearSignInFields();
      return true;
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(context, e.message ?? "An error occurred.");
    } finally {
      setLoading(false); // ✅ Stop loading
    }
    return false;
  }

  /// **Helper Method to Show Error Messages**
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white))),
    );
  }

  /// **Helper Method to Clear Sign-Up Fields**
  void _clearSignUpFields() {
    nameController.clear();
    emailControllerS.clear();
    passwordControllerS.clear();
    confirmPasswordControllerS.clear();
  }

  /// **Helper Method to Clear Sign-In Fields**
  void _clearSignInFields() {
    emailController.clear();
    passwordController.clear();
  }
}
