import 'package:flutter/material.dart';
import 'package:newapp/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeHeader extends StatelessWidget {
  final String username;

  const HomeHeader({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the user HRIS ID from the provider
    final userHris = Provider.of<UserProvider>(context).userHris;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10), // You can adjust or remove this if needed
        decoration: BoxDecoration(
          color: const Color(0xFF674AEF), // Theme color
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Beautifully styled Text with Charm font
            const Text(
              'Hayleys Electronics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18, // Adjust font size as needed
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5, // Add space between letters
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                    offset: Offset(3.0, 3.0),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                // Notification Icon with Count
                FutureBuilder<int>(
                  future: _fetchNotificationCount(userHris), // Fetch count
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Use ThreeRotatingDots
                      return const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 24.0,
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      final count = snapshot.data ?? 0;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications,
                                color: Colors.white),
                            onPressed: () {
                              // Handle notification icon press
                            },
                          ),
                          if (count > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$count', // Display the dynamic count
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                    return const Text('No data');
                  },
                ),
                const SizedBox(width: 10),
                // Username and Logout Button
                Row(
                  children: [
                    Text(
                      username, // Show username here
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.person, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'logout') {
                          _logout(context);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: const [
                                Icon(Icons.logout, color: Colors.black),
                                SizedBox(width: 10),
                                Text("Logout"),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fetch notification count from the server
  Future<int> _fetchNotificationCount(String userHris) async {
    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/ongoing_count.php?userHris=$userHris'));
      if (response.statusCode == 200) {
        // If the response body is a simple integer (e.g., 3), return it directly
        return int.parse(
            response.body); // Parse the response body directly as an integer
      } else {
        throw Exception('Failed to load notification count');
      }
    } catch (e) {
      print('Error fetching notification count: $e');
      return 0; // Return 0 in case of an error
    }
  }

  // Logout function to handle user logout
  void _logout(BuildContext context) {
    // Here, clear any session or login data if you're using any
    // You can also clear data from SharedPreferences or any other method you're using
    // If no shared preferences, then you might just reset the username.

    // For now, we'll navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/login');
  }
}
