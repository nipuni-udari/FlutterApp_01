import 'package:flutter/material.dart';
import 'package:newapp/screens/home/home_screen.dart';
import 'section_title.dart';

class SpecialSection extends StatelessWidget {
  const SpecialSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int cardsPerRow =
        (screenWidth / 250).floor(); // Adjust card width as needed

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Special for you",
            press: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._buildSpecialOfferCards(context, cardsPerRow),
              const SizedBox(width: 70),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSpecialOfferCards(BuildContext context, int cardsPerRow) {
    final List<Map<String, dynamic>> cardData = [
      {
        "image": "assets/images/Image Banner 2.jpg",
        "category": "Need attention",
        "numOfBrands": 18,
      },
      {
        "image": "assets/images/Image Banner 3.jpeg",
        "category": "Prospect",
        "numOfBrands": 24,
      },
      {
        "image": "assets/images/Image Banner 3.jpeg",
        "category": "Inquiries",
        "numOfBrands": 24,
      },
      {
        "image": "assets/images/Image Banner 3.jpeg",
        "category": "Inquiries",
        "numOfBrands": 24,
      },
    ];

    return cardData.map((data) {
      return SpecialOfferCard(
        image: data['image'],
        category: data['category'],
        numOfBrands: data['numOfBrands'],
        press: () {
          Navigator.pushNamed(context, HomeScreen.routeName);
        },
      );
    }).toList();
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 300, // Increased width
          height: 150, // Increased height
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity, // Ensure image covers the card
                  height: double.infinity,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: const TextStyle(
                            fontSize: 20, // Adjusted font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "$numOfBrands Brands",
                          style: const TextStyle(
                              fontSize: 16), // Adjusted font size
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
