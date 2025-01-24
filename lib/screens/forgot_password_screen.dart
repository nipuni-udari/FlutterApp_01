import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/screens/reset_otp_screen.dart';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFF674AEF);
  static const Color secondaryColor = Color.fromARGB(255, 11, 4, 43);
  static const Color buttonColor = Color.fromARGB(255, 116, 86, 247);

  Future<void> sendOtp(String mobileNumber) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/forgot_password.php');

    try {
      final response = await http.post(url, body: {'mobile': mobileNumber});

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          if (data['status'] == 'success') {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ResetOtpScreen(
                mobileNumber: mobileNumber,
                otp: '',
              ),
            ));
          } else {
            _showAlert(data['message'], null);
          }
        } catch (e) {
          _showAlert('Failed to parse response: ${e.toString()}', null);
        }
      } else {
        _showAlert(
            'HTTP Error: ${response.statusCode}. Please try again later.',
            null);
      }
    } catch (e) {
      _showAlert('An error occurred: ${e.toString()}', null);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  bool _isValidMobileNumber(String mobileNumber) {
    final regex = RegExp(r'^(?:\+94|94|0)?[0-9]{9}$');
    return regex.hasMatch(mobileNumber);
  }

  Future<void> _refreshFormField() async {
    // Clear the text field on refresh
    setState(() {
      _mobileController.clear();
    });

    // Simulate a short delay for better user experience
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                FadeInDown(
                  // Animation for the image
                  child: Image.asset(
                    'assets/images/illustration-2.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  // Animation for the title
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInUp(
                  // Animation for the description
                  child: const Text(
                    "Enter your registered phone number. We'll send you a verification code to reset your password.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 28),
                RefreshIndicator(
                  onRefresh: _refreshFormField,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      FadeInUp(
                        // Animation for the text field
                        child: TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            hintText: 'Enter mobile number',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      ZoomIn(
                        // Animation for the button
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final mobileNumber =
                                  _mobileController.text.trim();
                              if (mobileNumber.isEmpty) {
                                _showAlert(
                                    'Please enter a mobile number.', null);
                              } else if (!_isValidMobileNumber(mobileNumber)) {
                                _showAlert(
                                    'Please enter a valid Sri Lankan mobile number.',
                                    null);
                              } else {
                                sendOtp(mobileNumber);
                              }
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(buttonColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: _isLoading
                                ? const Text(
                                    'Sending...',
                                    style: TextStyle(fontSize: 16),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(14.0),
                                    child: Text(
                                      'Send OTP',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
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
