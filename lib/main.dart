import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Import the splash screen
import 'screens/welcome_screen.dart'; // Import the WelcomeScreen
import 'screens/login_screen.dart'; // Import the LoginScreen
import 'screens/signup_screen.dart'; // Import SignupScreen
import 'screens/home_screen.dart'; // Import SignupScreen

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
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => SplashScreen(), // SplashScreen route
        '/welcome': (context) => WelcomeScreen(), // WelcomeScreen route
        '/login': (context) => LoginScreen(), // LoginScreen route
        '/signup': (context) => SignupScreen(), // SignupScreen route
        '/home': (context) => HomeScreen(), // SignupScreen route
      },
    );
  }
}
