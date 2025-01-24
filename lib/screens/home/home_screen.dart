import 'package:flutter/material.dart';
import 'package:newapp/screens/home/components/special_section.dart';
import 'components/home_header.dart';
import 'package:newapp/screens/home/components/banner.dart';
import 'package:newapp/screens/home/components/categories.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    final String username =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(username: username), // Pass the username
              const CustomBanner(),
              const Categories(),
              const SpecialSection(),
            ],
          ),
        ),
      ),
    );
  }
}
