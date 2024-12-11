import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;
  Future<void> sendOtp(String mobileNumber) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'http://192.168.93.141/FlutterProjects/newapp/lib/php/otp_sms.php'); // Replace with your API endpoint
    try {
      final response = await http.post(url, body: {'contact': mobileNumber});

      if (response.statusCode == 200) {
        // Check if the response body is empty
        if (response.body.isEmpty) {
          _showAlert(
              'Empty response from server. Please try again later.', null);
          return;
        }

        // Parse the JSON
        final data = jsonDecode(response.body);

        if (data['status'] == '0') {
          // User does not exist
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const OtpScreen(),
          ));
        } else if (data['status'] == 'exists') {
          // User already exists
          _showAlert(data['message'], () {
            Navigator.of(context).pop(); // Close alert
            Navigator.of(context)
                .pushReplacementNamed('/login'); // Navigate to login
          });
        } else {
          _showAlert('Unexpected response from server.', null);
        }
      } else {
        _showAlert(
            'Error: ${response.statusCode}. Please try again later.', null);
      }
    } catch (e) {
      _showAlert('An error occurred: $e', null);
    }

    setState(() {
      _isLoading = false;
    });
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
    // Check if the input is exactly 9 digits
    final regex = RegExp(r'^\d{9}$');
    return regex.hasMatch(mobileNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF674AEF),
                const Color.fromARGB(255, 11, 4, 43),
              ],
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
                Image.asset(
                  'assets/images/illustration-2.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Registration',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Add your phone number. We'll send you a verification code so we know you're real.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Column(
                  children: [
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
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
                        prefix: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '(+94)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 178, 5, 253),
                            ),
                          ),
                        ),
                        suffixIcon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final mobileNumber = _mobileController.text.trim();
                          if (mobileNumber.isEmpty) {
                            _showAlert('Please enter a mobile number.', null);
                          } else if (!_isValidMobileNumber(mobileNumber)) {
                            _showAlert(
                                'Please enter a valid mobile number.', null);
                          } else {
                            sendOtp(mobileNumber);
                          }
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 116, 86, 247),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Send',
                                  style: TextStyle(fontSize: 16),
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
      ),
    );
  }
}
