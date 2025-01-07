// components/tab_view.dart
import 'package:flutter/material.dart';

class TabView extends StatelessWidget {
  final String tabName;

  const TabView({Key? key, required this.tabName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tab,
              color: const Color(0xFF674AEF),
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(
              'Content for $tabName Tab',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF674AEF),
              ),
            ),
            Text(
              'This is a more attractive design with the theme color applied.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
