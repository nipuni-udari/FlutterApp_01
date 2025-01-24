import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {
  final String username;

  const CustomBanner({
    Key? key,
    required this.username, // Add username as a required parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF674AEF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hayleys electronics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                // Replace the static text with dynamic username
                Text(
                  "Welcome, $username", // Display the username here
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/vector.png',
                fit: BoxFit.fitHeight,
                height: 120,
                width: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
