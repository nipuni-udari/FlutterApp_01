import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Import the splash screen
import 'screens/welcome_screen.dart'; // Import the WelcomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set the background color
      ),
      home: SplashScreen(), // Display the SplashScreen first
    );
  }
}
