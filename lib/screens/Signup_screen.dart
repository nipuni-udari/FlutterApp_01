import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapp/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  final String mobileNumber;

  const SignupScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late Color myColor;
  late Size mediaSize;
  late bool isLandscape;
  TextEditingController usernameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // To show loading indicator
  String errorMessage = ""; // To store error messages
  String successMessage = ""; // To store success messages
  bool _isPasswordVisible = false; // Toggle for password visibility

  // Function to validate email
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  // Function to handle sign-up
  Future<void> _signUp() async {
    // Validate input fields
    print("Mobile Number: ${widget.mobileNumber}");
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      return;
    }

    if (!_isValidEmail(emailController.text)) {
      _showErrorDialog("Please enter a valid email address.");
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
      errorMessage = ""; // Clear error messages
      successMessage = ""; // Clear previous success message
    });

    final String url =
        'https://demo.secretary.lk/electronics_mobile_app/backend/signup.php'; // Replace with your actual server URL
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'USERNAME': usernameController.text,
          'PASSWORD': passwordController.text,
          'EMAIL': emailController.text,
          'USER_ADDRESS': addressController.text,
          'mobile': widget.mobileNumber,
        },
      );
      print("Mobile Number: ${widget.mobileNumber}");
      print(response.statusCode);
      // Check if the response status is 200 (OK)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['status']);
        switch (data['status']) {
          case 'emailExist' || 'userNameExist':
            _showAlert(data['message'], () {
              setState(() {
                isLoading = false;
              });
            });
            break;
          case 'email&UserNameExist':
            _showAlert(data['message'], () {
              setState(() {
                isLoading = false;
              });
            });
            break;
          case 'success':
            _showAlert(data['message'], () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            });
            break;
          case 'error':
            _showAlert(data['message'], null);
            break;
          default:
            _showAlert('Unexpected response from server.', null);
        }
      } else {
        // If the status code is not 200, show a generic error message
        setState(() {
          isLoading = false; // Hide loading indicator
          errorMessage = "Server error. Please try again later.";
          successMessage = ""; // Clear success message
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Hide loading indicator
        errorMessage =
            "An error occurred. Please check your internet connection.";
        successMessage = ""; // Clear success message
      });
      print(error.toString()); // Log the error for debugging
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showAlert(String message, VoidCallback? onOkPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onOkPressed != null) onOkPressed();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
            // Animated background elements
            Positioned(
              left: 30,
              width: 80,
              height: 200,
              child: FadeInUp(
                duration: const Duration(seconds: 1),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/light-1.png'),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 140,
              width: 80,
              height: 150,
              child: FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/light-2.png'),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 40,
              top: 40,
              width: 80,
              height: 150,
              child: FadeInUp(
                duration: const Duration(milliseconds: 1300),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/clock.png'),
                    ),
                  ),
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),

            // Main content
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
                      padding: EdgeInsets.all(isLandscape ? 12 : 20),
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

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display success message
        if (successMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              successMessage,
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
        const SizedBox(height: 10),
        FadeInUp(
          duration: const Duration(milliseconds: 1900),
          child: _buildGreyText("Please sign up with your information"),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 2000),
          child: _buildGreyText("Username"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2100),
          child: _buildInputField(usernameController, icon: Icons.person),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 2000),
          child: _buildGreyText("Address"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2100),
          child: _buildInputField(addressController, icon: Icons.home),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 2200),
          child: _buildGreyText("Email address"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2300),
          child: _buildInputField(emailController, icon: Icons.email),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 2400),
          child: _buildGreyText("Password"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2500),
          child: _buildInputField(passwordController,
              isPassword: true, icon: Icons.lock),
        ),
        const SizedBox(height: 10),
        FadeInUp(
          duration: const Duration(milliseconds: 2700),
          child: _buildSignupButton(),
        ),
        const SizedBox(height: 20),

        // Sign-In Option below Sign Up Button
        FadeInUp(
          duration: const Duration(milliseconds: 2800),
          child: _buildSignUpOption(),
        ),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false,
      TextInputType keyboardType = TextInputType.text,
      IconData? icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      obscureText: isPassword ? !_isPasswordVisible : false,
      keyboardType: keyboardType,
    );
  }

  Widget _buildSignupButton() {
    return ElevatedButton(
      onPressed: _signUp,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
        backgroundColor: Color.fromARGB(255, 116, 86, 247),
        foregroundColor: Colors.white,
      ),
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : const Text("SIGN UP"),
    );
  }

  Widget _buildSignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            "Sign In",
            style: TextStyle(color: myColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
