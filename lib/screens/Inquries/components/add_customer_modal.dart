import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animate_do/animate_do.dart';

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

  // Email validation
  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
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
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Customer added successfully!')),
          );
          Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
        backgroundColor: const Color(0xFF674AEF),
        elevation: 0,
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideInLeft(
                duration: const Duration(milliseconds: 400),
                child: TextField(
                  controller: companyNameController,
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                    prefixIcon: const Icon(Icons.business),
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SlideInRight(
                duration: const Duration(milliseconds: 400),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SlideInLeft(
                duration: const Duration(milliseconds: 400),
                child: TextField(
                  controller: companyAddressController,
                  decoration: InputDecoration(
                    labelText: 'Company Address',
                    prefixIcon: const Icon(Icons.location_on),
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SlideInRight(
                duration: const Duration(milliseconds: 400),
                child: TextField(
                  controller: contactNoController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact No',
                    prefixIcon: const Icon(Icons.phone),
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeIn(
                              duration: const Duration(milliseconds: 500),
                              child: const Text(
                                'Saving...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
