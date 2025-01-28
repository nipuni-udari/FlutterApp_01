import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class AddCustomerModal extends StatefulWidget {
  const AddCustomerModal({Key? key}) : super(key: key);

  @override
  State<AddCustomerModal> createState() => _AddCustomerModalState();
}

class _AddCustomerModalState extends State<AddCustomerModal> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController contactNoController = TextEditingController();

  bool isLoading = false;
  double? latitude;
  double? longitude;

  // Email validation
  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Mobile number validation
  bool isValidMobile(String mobile) {
    final mobileRegex = RegExp(r'^\d{10}$');
    return mobileRegex.hasMatch(mobile);
  }

  void showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Determine location
  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      showAlert('Location Error', 'Unable to fetch location: $e');
    }
  }

  void saveCustomer() async {
    // Validate inputs
    if (emailController.text.isNotEmpty &&
        !isValidEmail(emailController.text)) {
      showAlert('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    if (contactNoController.text.isNotEmpty &&
        !isValidMobile(contactNoController.text)) {
      showAlert('Invalid Mobile Number',
          'Please enter a valid 10-digit mobile number.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Fetch location
    await getLocation();

    if (latitude == null || longitude == null) {
      setState(() {
        isLoading = false;
      });
      showAlert('Location Required', 'Please enable location services.');
      return;
    }

    const String url =
        'https://demo.secretary.lk/electronics_mobile_app/backend/save_customer.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'companyName': companyNameController.text,
          'email': emailController.text,
          'companyAddress': companyAddressController.text,
          'contactNo': contactNoController.text,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Customer added successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context)
                        .pop(); // Return to the previous screen
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(responseData['message'] ?? 'Failed to add customer.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error occurred. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Back Button
            Stack(
              children: [
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF674AEF), Color(0xFF4B2C8B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/customer.png',
                          width: size.width * 0.5,
                          height: size.height * 0.2,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add New Customer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 119, 9, 253)
                          .withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 9,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: companyNameController,
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                          prefixIcon: const Icon(Icons.business),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF674AEF), // Theme color
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF674AEF), // Theme color
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: companyAddressController,
                        decoration: InputDecoration(
                          labelText: 'Company Address',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF674AEF), // Theme color
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: contactNoController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Contact No',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF674AEF), // Theme color
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : saveCustomer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF674AEF),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: isLoading
                              ? const Text(
                                  'Saving...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const Text(
                                  'Save Customer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
