import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'components/tab_view.dart';
import 'components/add_inquiry_modal.dart';

class InquriesScreen extends StatefulWidget {
  const InquriesScreen({Key? key}) : super(key: key);

  @override
  State<InquriesScreen> createState() => _InquriesScreenState();
}

class _InquriesScreenState extends State<InquriesScreen> {
  int ongoingCount = 0;
  int prospectCount = 0;
  int NonprospectCount = 0;
  int confirmedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchOngoingCount();
    _fetchProspectCount();
    _fetchNonProspectCount();
    _fetchConfirmedCount();
  }

  Future<void> _fetchOngoingCount() async {
    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/ongoing_count.php'));
      if (response.statusCode == 200) {
        setState(() {
          ongoingCount =
              int.parse(response.body.trim()); // Parse and update the count
        });
      } else {
        print('Failed to fetch count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching count: $e');
    }
  }

  Future<void> _fetchProspectCount() async {
    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/prospect_count.php'));
      if (response.statusCode == 200) {
        setState(() {
          prospectCount =
              int.parse(response.body.trim()); // Update the prospect count
        });
      } else {
        print('Failed to fetch count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching count: $e');
    }
  }

  Future<void> _fetchNonProspectCount() async {
    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/nonprospect_count.php'));
      if (response.statusCode == 200) {
        setState(() {
          NonprospectCount =
              int.parse(response.body.trim()); // Update the nonprospect count
        });
      } else {
        print('Failed to fetch count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching count: $e');
    }
  }

  Future<void> _fetchConfirmedCount() async {
    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/confirmed_count.php'));
      if (response.statusCode == 200) {
        setState(() {
          confirmedCount =
              int.parse(response.body.trim()); // Update the confirmed count
        });
      } else {
        print('Failed to fetch count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Inquiries',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF674AEF),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.timer),
                text: 'Ongoing ($ongoingCount)', // Show dynamic ongoing count
              ),
              Tab(
                icon: const Icon(Icons.monetization_on),
                text:
                    'Prospect ($prospectCount)', // Show dynamic prospect count
              ),
              Tab(
                icon: const Icon(Icons.close),
                text:
                    'NonProspect ($NonprospectCount)', // Show dynamic nonprospect count
              ),
              Tab(
                icon: const Icon(Icons.check_circle),
                text:
                    'Confirmed ($confirmedCount)', // Show dynamic confirmed count
              ),
            ],
            labelColor: const Color.fromARGB(255, 144, 250, 218),
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8E8E8),
                Color(0xFFF9F9F9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TabBarView(
            children: [
              TabView(tabName: 'Ongoing'),
              TabView(tabName: 'Prospect'),
              TabView(tabName: 'NonProspect'),
              TabView(tabName: 'Confirmed'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddInquiryModal(),
          ),
          backgroundColor: const Color(0xFF674AEF),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Inquiry',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
