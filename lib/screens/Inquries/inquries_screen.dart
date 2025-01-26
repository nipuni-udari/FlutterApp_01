import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'dart:async'; // Importing the timer package
import 'package:newapp/user_provider.dart';
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

  Timer? _timer; // Declare a Timer

  @override
  void initState() {
    super.initState();
    _fetchCounts(); // Initial fetch
    _startAutoRefresh(); // Start auto-refreshing
  }

  // Function to fetch all counts
  Future<void> _fetchCounts() async {
    await _fetchOngoingCount();
    await _fetchProspectCount();
    await _fetchNonProspectCount();
    await _fetchConfirmedCount();
  }

  // Function to periodically refresh the counts
  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchCounts(); // Call the fetch function every 30 seconds
    });
  }

  // Function to stop auto-refresh if needed (e.g., when the screen is disposed)
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  Future<void> _fetchOngoingCount() async {
    final userHris = Provider.of<UserProvider>(context, listen: false)
        .userHris; // Get userHris from the provider

    try {
      final response = await http.get(
        Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/ongoing_count.php?userHris=$userHris',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          ongoingCount = int.parse(response.body.trim());
        });
      } else {
        print(
            'Failed to fetch ongoing count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ongoing count: $e');
    }
  }

  Future<void> _fetchProspectCount() async {
    final userHris = Provider.of<UserProvider>(context, listen: false).userHris;

    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/prospect_count.php?userHris=$userHris'));
      if (response.statusCode == 200) {
        setState(() {
          prospectCount = int.parse(response.body.trim());
        });
      } else {
        print(
            'Failed to fetch prospect count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching prospect count: $e');
    }
  }

  Future<void> _fetchNonProspectCount() async {
    final userHris = Provider.of<UserProvider>(context, listen: false).userHris;

    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/nonprospect_count.php?userHris=$userHris'));

      if (response.statusCode == 200) {
        setState(() {
          NonprospectCount = int.parse(response.body.trim());
        });
      } else {
        print(
            'Failed to fetch nonprospect count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching nonprospect count: $e');
    }
  }

  Future<void> _fetchConfirmedCount() async {
    final userHris = Provider.of<UserProvider>(context, listen: false).userHris;

    try {
      final response = await http.get(Uri.parse(
          'https://demo.secretary.lk/electronics_mobile_app/backend/confirmed_count.php?userHris=$userHris'));

      if (response.statusCode == 200) {
        setState(() {
          confirmedCount = int.parse(response.body.trim());
        });
      } else {
        print(
            'Failed to fetch confirmed count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching confirmed count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userHris = Provider.of<UserProvider>(context).userHris;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Inquiries For HRIS: ($userHris)',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF674AEF),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.timer),
                text: 'Ongoing ($ongoingCount)',
              ),
              Tab(
                icon: const Icon(Icons.monetization_on),
                text: 'Prospect ($prospectCount)',
              ),
              Tab(
                icon: const Icon(Icons.close),
                text: 'NonProspect ($NonprospectCount)',
              ),
              Tab(
                icon: const Icon(Icons.check_circle),
                text: 'Confirmed ($confirmedCount)',
              ),
            ],
            labelColor: const Color.fromARGB(255, 255, 234, 115),
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
