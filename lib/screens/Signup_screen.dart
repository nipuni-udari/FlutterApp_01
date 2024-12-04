import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert'; // Import for json decoding

import 'package:http/http.dart' as http; // Import the http package

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late Color myColor;
  late Size mediaSize;
  late bool isLandscape;
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // To show loading indicator when signing up
  String errorMessage = ""; // To store any error message

  // Function to handle sign-up
  Future<void> _signUp() async {
    // Validate input fields
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty) {
      setState(() {
        errorMessage = "Please fill in all fields.";
      });
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
      errorMessage = ""; // Reset any previous error message
    });

    final String url =
        'http://192.168.93.141/FlutterProjects/newapp/lib/php/register.php'; // Replace with your actual server URL

    try {
      // Send POST request with form data
      final response = await http.post(
        Uri.parse(url),
        body: {
          'USERNAME': usernameController.text,
          'PASSWORD': passwordController.text,
          'EMAIL': emailController.text,
          'MOBILE_NO': mobileController.text,
        },
      );

      // Decode the JSON response
      final Map<String, dynamic> responseData = json.decode(response.body);

      setState(() {
        isLoading = false; // Hide loading indicator
      });

      // Check if registration was successful
      if (responseData['success']) {
        // Registration success
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Registration Successful")));
        // Navigate to the login screen
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Registration failed
        setState(() {
          errorMessage =
              responseData['message'] ?? "An unknown error occurred.";
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Hide loading indicator on error
        errorMessage = "An error occurred. Please try again.";
      });
      print(error.toString()); // Log the error for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    myColor = Color(0xFF674AEF);
    mediaSize = MediaQuery.of(context).size;
    isLandscape = mediaSize.width > mediaSize.height;

    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.3), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0, 174, 22, 245),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: FadeInUp(
                    duration: const Duration(seconds: 1),
                    child: _buildTop(),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(
                          isLandscape ? 12 : 20), // Reduced padding
                      child: _buildBottom(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build top section with icon and title
  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_circle_rounded,
            size: isLandscape ? 80 : 100,
            color: Colors.white,
          ),
          Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isLandscape ? 30 : 40,
                letterSpacing: 2),
          ),
        ],
      ),
    );
  }

  // Build the bottom section with input fields and button
  Widget _buildBottom() {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0), // Reduced padding
        child: _buildForm(),
      ),
    );
  }

  // Build the form with input fields
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display any error messages
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),

        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Text(
            "Create Account",
            style: TextStyle(
                color: myColor,
                fontSize: isLandscape ? 28 : 32, // Adjust font size
                fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10), // Reduced space between title and text
        FadeInUp(
          duration: const Duration(milliseconds: 1900),
          child: _buildGreyText("Please sign up with your information"),
        ),
        const SizedBox(height: 20), // Reduced space after instruction text
        FadeInUp(
          duration: const Duration(milliseconds: 2000),
          child: _buildGreyText("Username"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2100),
          child: _buildInputField(usernameController),
        ),
        const SizedBox(height: 20), // Reduced space after username input field
        FadeInUp(
          duration: const Duration(milliseconds: 2000),
          child: _buildGreyText("Mobile"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2100),
          child: _buildInputField(mobileController),
        ),
        const SizedBox(height: 20), // Reduced space after mobile input field
        FadeInUp(
          duration: const Duration(milliseconds: 2200),
          child: _buildGreyText("Email address"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2300),
          child: _buildInputField(emailController),
        ),
        const SizedBox(height: 20), // Reduced space after email input field
        FadeInUp(
          duration: const Duration(milliseconds: 2400),
          child: _buildGreyText("Password"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2500),
          child: _buildInputField(passwordController, isPassword: true),
        ),
        const SizedBox(height: 10), // Reduced space after password input field
        FadeInUp(
          duration: const Duration(milliseconds: 2700),
          child: _buildSignupButton(),
        ),
        const SizedBox(height: 20), // Reduced space before next section
      ],
    );
  }

  // Build a text widget with grey color
  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  // Build input field for text input
  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }

  // Build the sign-up button
  Widget _buildSignupButton() {
    return ElevatedButton(
      onPressed: () {
        // Call _signUp() when the signup button is pressed
        _signUp();
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
        backgroundColor: Color.fromARGB(255, 116, 86, 247),
        foregroundColor: Colors.white, // Text color
      ),
      child: isLoading
          ? CircularProgressIndicator(
              color: Colors.white) // Show loading indicator
          : const Text("SIGN UP"),
    );
  }
}
