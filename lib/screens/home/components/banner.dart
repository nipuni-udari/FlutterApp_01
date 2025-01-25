import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {
  final String username;
  final String userHris;

  const CustomBanner({
    Key? key,
    required this.username,
    required this.userHris,
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
                  "Hayleys Electronics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                // Dynamic text with username and userHris
                Text(
                  "Welcome, $username ($userHris)", // Display both username and userHris
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Adjusted font size for better readability
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/images/vector.png',
              fit: BoxFit.contain, // Adjusted to fit better
              height: 120,
              width: 120, // Adjusted to match height
              errorBuilder: (context, error, stackTrace) {
                // Handle missing image gracefully
                return const Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                  size: 60,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
