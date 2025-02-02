import 'package:flutter/material.dart';
import 'package:newapp/screens/Inquries/inquries_screen.dart';
import 'package:newapp/screens/home/components/calender.dart';
import 'package:newapp/screens/home/components/special_section.dart';
import 'package:newapp/screens/profile/user_profile.dart';
import 'package:newapp/user_provider.dart';
import 'package:provider/provider.dart';
import 'components/custom_bottom_navbar.dart';
import 'package:newapp/screens/home/components/banner.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of screens to display
  final List<Widget> _pages = [
    HomeContent(), // HomeScreen content
    InquriesScreen(), // Inquiries screen
    ProfilePage(), // Profile screen
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF674AEF),
    ));
    super.dispose();
  }

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<int> _fetchNotificationCount(String userHris) async {
    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/ongoing_count.php?userHris=$userHris'));
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception('Failed to load notification count');
      }
    } catch (e) {
      print('Error fetching notification count: $e');
      return 0;
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String username = args['username'];
    final String userHris = args['userHris'];

    Provider.of<UserProvider>(context, listen: false)
        .setUser(username, userHris);

    return Scaffold(
      // AppBar is only part of the HomeScreen
      appBar: _currentIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false, // Remove the back button
              backgroundColor: const Color(0xFF674AEF),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              elevation: 10,
              title: const Text(
                'Hayleys Electronics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Color.fromARGB(255, 16, 16, 16),
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
              actions: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return Row(
                      children: [
                        FutureBuilder<int>(
                          future:
                              _fetchNotificationCount(userProvider.userHris),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 24.0,
                              );
                            } else if (snapshot.hasError) {
                              return const Text(
                                'Error',
                                style: TextStyle(color: Colors.white),
                              );
                            } else if (snapshot.hasData) {
                              final count = snapshot.data ?? 0;
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.notifications,
                                        color: Colors.white),
                                    onPressed: () {
                                      // Handle notification
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          '$count',
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
                            return const Text(
                              'No data',
                              style: TextStyle(color: Colors.white),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            Text(
                              userProvider.username,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            PopupMenuButton<String>(
                              icon:
                                  const Icon(Icons.person, color: Colors.white),
                              onSelected: (value) {
                                if (value == 'logout') {
                                  _logout(context);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'logout',
                                    child: Row(
                                      children: [
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
                    );
                  },
                ),
              ],
            )
          : null, // No AppBar for other screens
      body: _pages[_currentIndex], // Display the selected screen
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _updateIndex(index);
        },
      ),
    );
  }
}

// HomeScreen content (moved to a separate widget)
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 8,
        radius: const Radius.circular(8),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  return CustomBanner(
                    username: userProvider.username,
                    userHris: userProvider.userHris,
                  );
                },
              ),
              SpecialSection(onCardTap: (index) {
                // Handle card tap if needed
              }),
              CalendarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
