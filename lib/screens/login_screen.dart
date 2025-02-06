import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newapp/screens/forgot_password_screen.dart';
import 'package:newapp/screens/home/home_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  bool isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMobile = prefs.getString('mobile');
    final savedPassword = prefs.getString('password');
    final savedRemember = prefs.getBool('rememberUser') ?? false;

    if (savedRemember && savedMobile != null && savedPassword != null) {
      setState(() {
        mobileController.text = savedMobile;
        passwordController.text = savedPassword;
        rememberUser = savedRemember;
      });
      // Trigger auto-login after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _login();
      });
    }
  }

  Future<void> _refreshFormFields() async {
    setState(() {
      mobileController.clear();
      passwordController.clear();
      rememberUser = false;
    });
    // Add a short delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberUser) {
      await prefs.setString('mobile', mobileController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('rememberUser', true);
    } else {
      await prefs.remove('mobile');
      await prefs.remove('password');
      await prefs.setBool('rememberUser', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    myColor = const Color(0xFF674AEF);
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
        body: RefreshIndicator(
          onRefresh: _refreshFormFields,
          child: Stack(
            children: [
              // Back Button
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/welcome');
                  },
                ),
              ),
              // Animated Background Elements
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
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
        FadeInUp(
          duration: const Duration(milliseconds: 2100),
          child: _buildGreyText("Mobile Number"),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 2200),
          child: _buildInputField(mobileController),
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
      keyboardType: isPassword ? TextInputType.text : TextInputType.phone,
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
            : const Icon(Icons.done),
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
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen(),
              ),
            );
          },
          child: Text(
            "forgot my password",
            style: TextStyle(color: myColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        FocusScope.of(context).unfocus();

        if (mobileController.text.isEmpty || passwordController.text.isEmpty) {
          _showAlert("Error", "Please enter both mobile and password.");
          return;
        }

        setState(() {
          isLoading = true;
        });
        await _login();

        setState(() {
          isLoading = false;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
        backgroundColor: const Color.fromARGB(255, 116, 86, 247),
        foregroundColor: Colors.white,
      ),
      child: isLoading
          ? FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: const Text(
                'Logging in...',
                style: TextStyle(fontSize: 20),
              ),
            )
          : const Text(
              'Login',
              style: TextStyle(fontSize: 20),
            ),
    );
  }

  Future<void> _login() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showAlert("Error", "No internet connection. Please check your network.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://demo.secretary.lk/electronics_mobile_app/backend/login.php'),
        body: {
          'mobile': mobileController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success']) {
          await _saveCredentials();
          Navigator.pushReplacementNamed(
            context,
            HomeScreen.routeName,
            arguments: {
              'username': data['username'],
              'userHris': data['userHris'],
            },
          );
        } else {
          _showAlert("Login Failed", data['message']);
        }
      } else {
        _showAlert(
            "Error", "Unexpected server response: ${response.statusCode}");
      }
    } catch (e) {
      _showAlert("Error", "Connection failed. Please try again.");
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignUpOption() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/signup');
        },
        child: RichText(
          text: TextSpan(
            //text: "Don't have an account? ",
            style: const TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                //text: "Sign up",
                style: TextStyle(
                    color: myColor, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
