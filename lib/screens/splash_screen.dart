import 'package:flutter/material.dart';
import 'dart:async';
import 'package:newapp/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for the splash screen (e.g., 3 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the LoginScreen after the delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use BoxDecoration to apply a gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(143, 148, 251, 1), // Start color
              Color.fromRGBO(70, 78, 226, 1), // End color
            ],
            begin: Alignment.topLeft, // Gradient starts from top left
            end: Alignment.bottomRight, // Gradient ends at bottom right
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(seconds: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png',
                    width: 200, height: 200), // Add your logo here
                const SizedBox(height: 20),
                const Text(
                  'Welcome to My App', // Splash screen text
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
