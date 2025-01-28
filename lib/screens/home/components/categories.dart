import 'package:flutter/material.dart';
import 'package:newapp/screens/Inquries/inquries_screen.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "icon": Icons.flash_on,
        "text": "Inquiries",
        "onTap": () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InquriesScreen()),
            ),
      },
      {"icon": Icons.receipt, "text": "Upcoming", "onTap": () {}},
      {"icon": Icons.videogame_asset, "text": "Upcoming", "onTap": () {}},
      {"icon": Icons.card_giftcard, "text": "Upcoming", "onTap": () {}},
      {"icon": Icons.more_horiz, "text": "More", "onTap": () {}},
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: categories[index]["onTap"],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 239, 236, 252),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF674AEF),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
