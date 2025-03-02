import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_screens/signin_screen.dart';
import '../providers/auth_provier.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: authProvider.signUpFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Sign Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _buildInputField(
                  controller: authProvider.nameController,
                  label: "Full Name",
                  validator: (value) => value!.isEmpty ? "Please enter your name" : null,
                ),
                SizedBox(height: 15),
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
                SizedBox(height: 15),
                _buildInputField(
                  controller: authProvider.confirmPasswordControllerS,
                  label: "Confirm Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please confirm your password";
                    if (value != authProvider.passwordController.text) return "Passwords do not match";
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: ()async  {
                    bool  istrue = await authProvider.signUp(context);
                    if(istrue){
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("Sign Up"),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  ),
                  child: Text(
                    "Already have an account? Sign In",
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
