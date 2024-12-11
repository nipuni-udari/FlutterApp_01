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

  // Constants for UI styling
  static const Color primaryColor = Color(0xFF674AEF);
  static const Color secondaryColor = Color.fromARGB(255, 11, 4, 43);
  static const Color buttonColor = Color.fromARGB(255, 116, 86, 247);

  Future<void> sendOtp(String mobileNumber) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'http://192.168.93.141/FlutterProjects/newapp/lib/php/otp_sms.php'); // Replace with your API endpoint
    try {
      final response = await http.post(url, body: {'mobile': mobileNumber});

      // Print the raw response for debugging
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          switch (data['status']) {
            case 'success':
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const OtpScreen(),
              ));
              break;
            case 'exists':
              _showAlert(data['message'], () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              });
              break;
            case 'error':
              _showAlert(data['message'], null);
              break;
            default:
              _showAlert('Unexpected response from server.', null);
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
    // Matches valid Sri Lankan numbers with +94 or 0 prefixes and 9 digits after the prefix
    final regex = RegExp(r'^(?:\+94|94|0)?[1-9]\d{8}$');
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
                            buttonColor,
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
