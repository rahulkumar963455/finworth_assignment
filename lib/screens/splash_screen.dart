import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_example/auth_screens/signin_screen.dart';
import 'package:sqflite_example/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    // Navigate after 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; // Ensure widget is still in the tree before navigating

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => isLoggedIn ? HomeScreen() : SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.5 + (value * 0.5),
              child: Opacity(
                opacity: value,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Assignment ",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      TextSpan(
                        text: "of ",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellow),
                      ),
                      TextSpan(
                        text: "Fine",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      TextSpan(
                        text: "Worth",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
