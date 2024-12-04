import 'package:flutter/material.dart';
import 'package:newapp/screens/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height /
                      1.6, // Adjust as needed
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF674AEF),
                        Color.fromARGB(255, 11, 4, 43),
                      ], // Define your gradient colors here
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(70)),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/welcome.png", // Make sure this is the correct image path
                      width: MediaQuery.of(context).size.width *
                          0.7, // Adjust the image width (70% of the screen width)
                      height: MediaQuery.of(context).size.height *
                          0.5, // Adjust the image height (30% of the screen height)
                      fit: BoxFit.contain, // Adjust how the image fits
                    ),
                  ),
                ),
              ],
            ),
            // Bottom purple section
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height /
                    2.666, // Adjust as needed
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 11, 4, 43), // Background color
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.66,
                padding: EdgeInsets.only(top: 40, bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "The most Secure Platform for Customers",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Built-in Fingerprint, face recognition, and more, keeping you completely safe",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    // Get Started Button with adjusted width
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.6, // 50% of screen width
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to signup_screen.dart
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          elevation: 20,
                          shadowColor: const Color.fromARGB(255, 140, 153,
                              253), // Use the desired shadow color
                          minimumSize: const Size.fromHeight(60),
                          backgroundColor: Color.fromARGB(255, 116, 86, 247),
                          foregroundColor: Colors.white, // Text color
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 22,
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
