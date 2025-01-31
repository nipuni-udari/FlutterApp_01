import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:newapp/screens/mobile_register.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 174, 22, 245),
      body: Stack(
        children: [
          // Full-screen gradient background
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF674AEF),
                  Color.fromARGB(255, 11, 4, 43),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Animated Positioned Images
          Positioned(
            left: 30,
            width: 80,
            height: 200,
            child: FadeInUp(
              duration: const Duration(seconds: 1),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/light-1.png'),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 140,
            width: 80,
            height: 150,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/light-2.png'),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            top: 40,
            width: 80,
            height: 150,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1300),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/clock.png'),
                  ),
                ),
              ),
            ),
          ),
          // Main Content
          Column(
            children: [
              // Image Animation (Top)
              SizedBox(height: screenHeight * 0.15),
              FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: Center(
                  child: Image.asset(
                    "assets/images/robot.png",
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // White content section
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                      width: screenWidth,
                      height: screenHeight / 2.5,
                      padding: const EdgeInsets.only(top: 40, bottom: 30),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          topRight: Radius.circular(70),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title text with animation
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Text(
                              "The Most Secure Platform for Hayleys Electronics",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 20 : 25,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 2, 128, 90),
                                letterSpacing: 1,
                                wordSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Subtitle with animation
                          FadeInUp(
                            duration: const Duration(milliseconds: 1800),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1),
                              child: const Text(
                                "OTP verifications, Email verifications and more, keeping you completely safe",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          // Get Started Button with animation
                          FadeInUp(
                            duration: const Duration(milliseconds: 2000),
                            child: SizedBox(
                              width: screenWidth * 0.6,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MobileScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  elevation: 20,
                                  shadowColor:
                                      const Color.fromARGB(255, 140, 153, 253),
                                  minimumSize: const Size.fromHeight(60),
                                  backgroundColor:
                                      const Color.fromARGB(255, 116, 86, 247),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontSize: screenWidth < 400 ? 18 : 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
