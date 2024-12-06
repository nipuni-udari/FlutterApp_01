import 'package:flutter/material.dart';
import 'package:newapp/screens/mobile_register.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Material(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Background gradient container
            Container(
              width: screenWidth,
              height: screenHeight / 1.6, // Adjust based on screen height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF674AEF),
                    Color.fromARGB(255, 11, 4, 43),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(70)),
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/welcome.png",
                  width: screenWidth * 0.7, // 70% of screen width
                  height: screenHeight *
                      0.4, // Adjust image height based on screen height
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Bottom purple section
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: screenWidth,
                height:
                    screenHeight / 2.666, // Adjust height of bottom container
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 11, 4, 43),
                ),
              ),
            ),
            // White content section
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: screenWidth,
                height: screenHeight / 2.66,
                padding: EdgeInsets.only(top: 40, bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title text
                    Text(
                      "The most Secure Platform for Customers",
                      style: TextStyle(
                        fontSize: screenWidth < 400
                            ? 20
                            : 25, // Adjust font size based on screen width
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1), // Responsive padding
                      child: Text(
                        "Built-in Fingerprint, face recognition, and more, keeping you completely safe",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth < 400
                              ? 14
                              : 17, // Adjust text size for smaller screens
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05), // Dynamic spacing

                    // Get Started Button with adjusted width
                    SizedBox(
                      width: screenWidth *
                          0.6, // Button width as 60% of screen width
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to signup_screen.dart
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MobileScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          elevation: 20,
                          shadowColor: Color.fromARGB(255, 140, 153, 253),
                          minimumSize: Size.fromHeight(60),
                          backgroundColor: Color.fromARGB(255, 116, 86, 247),
                          foregroundColor: Colors.white, // Text color
                        ),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: screenWidth < 400
                                ? 18
                                : 22, // Font size adjustment
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
