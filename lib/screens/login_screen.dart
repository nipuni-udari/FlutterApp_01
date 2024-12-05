import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  bool isLoading = false;
  String errorMessage = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    myColor = Color(0xFF674AEF);
    mediaSize = MediaQuery.of(context).size;

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
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          // Remove this error display to avoid duplication
                          _buildBottom(),
                        ],
                      ),
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
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "Login",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
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
        padding: const EdgeInsets.all(32.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display error message only once before "Welcome Back" text
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Text(
            "Welcome Back",
            style: TextStyle(
                color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 1900),
          child: _buildGreyText("Please log in to your account"),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 2100),
          child: _buildGreyText("Email address"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2200),
          child: _buildInputField(emailController),
        ),
        const SizedBox(height: 40),
        FadeInUp(
          duration: const Duration(milliseconds: 2300),
          child: _buildGreyText("Password"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2400),
          child: _buildInputField(passwordController, isPassword: true),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 2500),
          child: _buildRememberForgot(),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 2600),
          child: _buildLoginButton(),
        ),
        const SizedBox(height: 40),
        FadeInUp(
          duration: const Duration(milliseconds: 2700),
          child: _buildSignUpOption(),
        ),
        const SizedBox(height: 40),
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
            : Icon(Icons.done),
      ),
      obscureText: isPassword ? !_isPasswordVisible : false,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Remember me"),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "I forgot my password",
            style: TextStyle(color: myColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        // Dismiss the keyboard when login button is pressed
        FocusScope.of(context).unfocus();

        // Check if email and password are not empty
        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
          setState(() {
            errorMessage = "Please enter both email and password.";
          });
          return;
        }

        // Start loading
        setState(() {
          isLoading = true;
          errorMessage = ''; // Reset error message on login attempt
        });

        // Perform login
        await _login();

        // Stop loading
        setState(() {
          isLoading = false;
        });
      },
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
          : Text(
              'Login',
              style: TextStyle(fontSize: 20),
            ),
    );
  }

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.93.141/FlutterProjects/newapp/lib/php/login.php'),
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      // debugPrint(response);
      debugPrint(response.body);
      final data = json.decode(response.body);

      if (data['success']) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (data['message'] == 'User does not exist') {
        setState(() {
          errorMessage = 'User does not exist. Please check your email.';
        });
      } else if (data['message'] == 'Incorrect password') {
        setState(() {
          errorMessage = 'Incorrect password. Please try again.';
        });
      } else {
        setState(() {
          errorMessage = 'An error occurred. Please try again laterr.';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }

  Widget _buildSignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signup');
          },
          child: Text(
            "Sign Up",
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
