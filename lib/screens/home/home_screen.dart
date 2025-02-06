import 'package:flutter/material.dart';
import 'package:newapp/screens/Inquries/inquries_screen.dart';
import 'package:newapp/screens/home/components/calender.dart';
import 'package:newapp/screens/home/components/special_section.dart';
import 'package:newapp/screens/profile/user_profile.dart';
import 'package:newapp/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/custom_bottom_navbar.dart';
//import 'package:newapp/screens/home/components/banner.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnectivity(context);
    });

    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkConnectivity(context);
      });
    });

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

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Clear saved credentials but keep the rememberUser flag
    await prefs.remove('mobile');
    await prefs.remove('password');

    // Navigate to login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _checkConnectivity(BuildContext context) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No internet connection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to mobile network'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-Fi is available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to Wi-Fi'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to Ethernet'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // VPN connection active
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected via VPN'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected via Bluetooth'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to an unknown network'),
          backgroundColor: Colors.green,
        ),
      );
    }
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
      HomeContent(
        onCardTap: () => _updateIndex(1), // Handle card taps here
      ),
      InquriesScreen(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
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
                                    onPressed: () {},
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
          : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _updateIndex(index);
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final VoidCallback onCardTap;

  const HomeContent({Key? key, required this.onCardTap}) : super(key: key);

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
              SpecialSection(
                onCardTap: (index) => onCardTap(), // Handle card tap here
              ),
              CalendarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
