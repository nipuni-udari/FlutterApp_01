import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Import animate_do package

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
            // Background Images with FadeInUp animation
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

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top Part with Sign Up Title and Icon
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
        // Removed Other Signup options
        const SizedBox(height: 30), // Reduced space before the "Sign in" option
        FadeInUp(
          duration: const Duration(milliseconds: 2800),
          child: _buildSignInOption(),
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
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildSignupButton() {
    return ElevatedButton(
      onPressed: () {
        debugPrint("Username : ${usernameController.text}");
        debugPrint("Mobile : ${mobileController.text}");
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
        backgroundColor: Color.fromARGB(255, 116, 86, 247),
        foregroundColor: Colors.white, // Text color
      ),
      child: const Text("SIGN UP"),
    );
  }

  Widget _buildSignInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ",
            style: TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: () {
            // Navigate to the sign-in screen (you should define this route in your app)
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            "Sign In",
            style: TextStyle(
              color: myColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
