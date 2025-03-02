import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Helper function for email validation
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email);
  }

  /// **Sign Up Method (Firebase)**
  Future<bool> signUp(BuildContext context) async {
    if (!signUpFormKey.currentState!.validate()) {
      print("Form validation failed");
      return false;
    }

    String email = emailControllerS.text.trim();
    String password = passwordControllerS.text.trim();

    try {
      print("Creating user with email: $email");

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("User Created Successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully!")),
      );

      _clearSignUpFields();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showErrorMessage(context, "This email is already in use.");
      } else if (e.code == 'weak-password') {
        _showErrorMessage(context, "The password provided is too weak.");
      } else if (e.code == 'invalid-email') {
        _showErrorMessage(context, "The email address is badly formatted.");
      } else {
        _showErrorMessage(context, e.message ?? "An unexpected error occurred.");
      }
      return false; // Return false to indicate failure
    } catch (e) {
      _showErrorMessage(context, "Error: ${e.toString()}");
      return false; // Return false to indicate failure
    }
  }

  /// **Sign In Method (Firebase)**
  Future<bool> signIn(BuildContext context) async {
    if (!signInFormKey.currentState!.validate()) return false;

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signed in successfully!")),
      );

      // Clear fields after successful sign-in
      _clearSignInFields();

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorMessage(context, "No user found for this email.");
      } else if (e.code == 'wrong-password') {
        _showErrorMessage(context, "Incorrect password.");
      } else {
        _showErrorMessage(context, e.message ?? "An unexpected error occurred.");
      }
    } catch (e) {
      _showErrorMessage(context, "Error: ${e.toString()}");
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