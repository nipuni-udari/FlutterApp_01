import 'package:flutter/material.dart';
import 'package:newapp/screens/home/components/calender.dart';
import 'package:newapp/screens/home/components/special_section.dart';
import 'package:newapp/user_provider.dart';
import 'package:provider/provider.dart';
import 'components/home_header.dart';
import 'package:newapp/screens/home/components/banner.dart';
import 'package:newapp/screens/home/components/categories.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String username = args['username'];
    final String userHris = args['userHris'];

    // Set the user data in UserProvider
    Provider.of<UserProvider>(context, listen: false)
        .setUser(username, userHris);

    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true, // Makes the scroll bar always visible
          thickness: 8, // Adjusts the width of the scrollbar
          radius: Radius.circular(8), // Gives the scrollbar rounded corners
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                HomeHeader(username: username),
                CustomBanner(username: username, userHris: userHris),
                const Categories(),
                const SpecialSection(),
                CalendarWidget(), // Add the calendar widget here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
