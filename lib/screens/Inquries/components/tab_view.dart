import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ongoing_table.dart';

class TabView extends StatefulWidget {
  final String tabName;

  const TabView({Key? key, required this.tabName}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  List<dynamic> inquiries = [];

  @override
  void initState() {
    super.initState();
    fetchInquiries();
  }

  Future<void> fetchInquiries() async {
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_ongoing_inquiries.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        inquiries = json.decode(response.body);
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content for ${widget.tabName} Tab',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF674AEF),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: OngoingTable(inquiries: inquiries),
          ),
        ],
      ),
    );
  }
}
