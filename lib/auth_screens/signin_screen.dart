import 'package:sqflite_example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_screens/sign_up_screen.dart';
import '../providers/auth_provier.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: authProvider.signInFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Sign In", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _buildInputField(
                  controller: authProvider.emailController,
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter your email";
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                _buildInputField(
                  controller: authProvider.passwordController,
                  label: "Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter your password";
                    if (value.length < 6) return "Password must be at least 6 characters long";
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // ✅ Show CircularProgressIndicator when signing in
                authProvider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () async {
                    bool istrue = await authProvider.signIn(context);
                    if (istrue) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("Sign In"),
                ),

                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  ),
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
