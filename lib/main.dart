import 'package:flutter/material.dart';
import 'package:newapp/screens/Inquries/inquries_screen.dart';
import 'package:newapp/screens/forgot_password_screen.dart';
import 'package:newapp/screens/reset_password_screen.dart';
import 'screens/reset_otp_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/mobile_register.dart';
import 'screens/otp_screen.dart';

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
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(
              mobileNumber: '',
            ),
        '/home': (context) => HomeScreen(),
        '/mobile': (context) => MobileScreen(),
        '/inquries': (context) => InquriesScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
        '/reset_Password': (context) => ResetPasswordScreen(
              mobileNumber: '',
              otp: '',
            ),
        '/otp': (context) => OtpScreen(
              mobileNumber: '',
              otp: '',
            ),
        '/reset_otp': (context) => ResetOtpScreen(
              mobileNumber: '',
              otp: '',
            ),
      },
    );
  }
}
