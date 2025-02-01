import 'package:flutter/material.dart';
import 'package:newapp/screens/Inquries/inquries_screen.dart';
import 'package:newapp/screens/home/components/calender.dart';
import 'package:newapp/screens/home/components/special_section.dart';
import 'package:newapp/screens/welcome_screen.dart';
import 'package:newapp/user_provider.dart';
import 'package:provider/provider.dart';
import 'components/custom_bottom_navbar.dart';
import 'components/home_header.dart';
import 'package:newapp/screens/home/components/banner.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String username = args['username'];
    final String userHris = args['userHris'];

    Provider.of<UserProvider>(context, listen: false)
        .setUser(username, userHris);

    final List<Widget> _pages = [
      _buildHomePage(username, userHris),
      InquriesScreen(),
      WelcomeScreen(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _updateIndex(index);
        },
      ),
    );
  }

  Widget _buildHomePage(String username, String userHris) {
    return SafeArea(
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 8,
        radius: Radius.circular(8),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(username: username),
              CustomBanner(username: username, userHris: userHris),
              SpecialSection(onCardTap: _updateIndex), // Pass function
              CalendarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
