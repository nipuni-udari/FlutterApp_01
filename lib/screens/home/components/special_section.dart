import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/user_provider.dart';
import 'section_title.dart';

class SpecialSection extends StatelessWidget {
  const SpecialSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int cardsPerRow =
        (screenWidth / 250).floor(); // Adjust card width as needed
    final userHris = Provider.of<UserProvider>(context).userHris;

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
              ..._buildSpecialOfferCards(context, userHris),
              const SizedBox(width: 70),
            ],
          ),
        ),
      ],
    );
  }

  List<CardData> _cardData(String userHris) => [
        CardData(
          image: "assets/images/Image Banner 2.jpg",
          category: "Ongoing",
          statusUrl:
              'https://demo.secretary.lk/electronics_mobile_app/backend/ongoing_count.php?userHris=$userHris',
        ),
        CardData(
          image: "assets/images/Image Banner 3.jpg",
          category: "Prospect",
          statusUrl:
              'https://demo.secretary.lk/electronics_mobile_app/backend/prospect_count.php?userHris=$userHris',
        ),
        CardData(
          image: "assets/images/Image Banner 4.jpg",
          category: "Non Prospect",
          statusUrl:
              'https://demo.secretary.lk/electronics_mobile_app/backend/nonprospect_count.php?userHris=$userHris',
        ),
        CardData(
          image: "assets/images/Image Banner 5.jpg",
          category: "Confirmed",
          statusUrl:
              'https://demo.secretary.lk/electronics_mobile_app/backend/confirmed_count.php?userHris=$userHris',
        ),
      ];

  List<Widget> _buildSpecialOfferCards(BuildContext context, String userHris) {
    final cardData = _cardData(userHris);

    return cardData.map((data) {
      return SpecialOfferCard(
        cardData: data,
        press: () {
          Navigator.pushNamed(context, '/inquries');
        },
      );
    }).toList();
  }
}

class CardData {
  final String image;
  final String category;
  final String statusUrl;
  String? statusCount;

  CardData({
    required this.image,
    required this.category,
    required this.statusUrl,
    this.statusCount,
  });
}

class SpecialOfferCard extends StatefulWidget {
  const SpecialOfferCard({
    Key? key,
    required this.cardData,
    required this.press,
  }) : super(key: key);

  final CardData cardData;
  final GestureTapCallback press;

  @override
  _SpecialOfferCardState createState() => _SpecialOfferCardState();
}

class _SpecialOfferCardState extends State<SpecialOfferCard> {
  String? statusCount;
  bool isHovered = false;
  Timer? _timer; // Timer for auto-refresh

  @override
  void initState() {
    super.initState();
    fetchStatusCount();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchStatusCount();
    });
  }

  Future<void> fetchStatusCount() async {
    try {
      final response = await http.get(Uri.parse(widget.cardData.statusUrl));
      if (response.statusCode == 200) {
        setState(() {
          statusCount = response.body;
        });
      } else {
        setState(() {
          statusCount = "Error";
        });
      }
    } catch (e) {
      setState(() {
        statusCount = "Error";
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: widget.press,
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isHovered ? 320 : 300,
            height: isHovered ? 180 : 150,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(widget.cardData.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        const Color.fromARGB(79, 126, 2, 235),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.cardData.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.analytics,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            statusCount ?? "Loading...",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
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
