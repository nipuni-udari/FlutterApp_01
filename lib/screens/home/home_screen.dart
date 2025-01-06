import 'package:flutter/material.dart';
import 'package:newapp/screens/home/components/special_section.dart';
import 'components/home_header.dart';
import 'package:newapp/screens/home/components/banner.dart';
import 'package:newapp/screens/home/components/categories.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(),
              CustomBanner(),
              Categories(),
              SpecialSection(),
            ],
          ),
        ),
      ),
    );
  }
}
