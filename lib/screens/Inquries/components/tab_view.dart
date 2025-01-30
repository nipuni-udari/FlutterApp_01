import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:newapp/user_provider.dart';
import 'dart:async';
import 'Tables/ongoing_table.dart';
import 'Tables/prospect_table.dart';
import 'Tables/nonProspect_table.dart';
import 'Tables/confirm_table.dart';

class TabView extends StatefulWidget {
  final String tabName;

  const TabView({Key? key, required this.tabName}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  List<dynamic> inquiries = [];
  List<dynamic> previousInquiries = []; // Store previous data for comparison
  Timer? _timer; // Timer for periodic updates

  @override
  void initState() {
    super.initState();
    if (widget.tabName == 'Ongoing') {
      fetchOngoingInquiries();
    } else if (widget.tabName == 'Prospect') {
      fetchProspectInquiries();
    } else if (widget.tabName == 'NonProspect') {
      fetchNonProspectInquiries();
    } else if (widget.tabName == 'Confirmed') {
      fetchConfirmedInquiries();
    }

    // Start a timer to periodically check for updates
    _startAutoRefresh();
  }

  // Start periodic data refresh
  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (widget.tabName == 'Ongoing') {
        fetchOngoingInquiries();
      } else if (widget.tabName == 'Prospect') {
        fetchProspectInquiries();
      } else if (widget.tabName == 'NonProspect') {
        fetchNonProspectInquiries();
      } else if (widget.tabName == 'Confirmed') {
        fetchConfirmedInquiries();
      }
    });
  }

  // Compare new data with previous data before updating the state
  void _updateInquiries(List<dynamic> newInquiries) {
    if (newInquiries.toString() != previousInquiries.toString()) {
      setState(() {
        inquiries = newInquiries;
        previousInquiries =
            newInquiries; // Update previous data for future comparison
      });
    }
  }

  Future<void> fetchOngoingInquiries() async {
    final userHris = Provider.of<UserProvider>(context, listen: false).userHris;
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_ongoing_inquiries.php');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'userHris': userHris,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List && data.isNotEmpty) {
        // If data is available, update the inquiries only if it's changed
        _updateInquiries(data);
      } else {
        // If no data found for the user, show a warning SnackBar
        _showNoDataWarning();
      }
    } else {
      print('Failed to load ongoing data: ${response.body}');
    }
  }

  Future<void> fetchProspectInquiries() async {
    final userHris = Provider.of<UserProvider>(context, listen: false).userHris;
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_prospect_inquiries.php');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'userHris': userHris,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _updateInquiries(data); // Update inquiries only if changed
    } else {
      print('Failed to load prospect data: ${response.body}');
    }
  }

  Future<void> fetchNonProspectInquiries() async {
    final userHris = Provider.of<UserProvider>(context, listen: false).userHris;
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_NonProspect_inquiries.php');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'userHris': userHris,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _updateInquiries(data); // Update inquiries only if changed
    } else {
      print('Failed to load non prospect data: ${response.body}');
    }
  }

  Future<void> fetchConfirmedInquiries() async {
    final userHris = Provider.of<UserProvider>(context, listen: false).userHris;
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_confirmed_inquiries.php');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'userHris': userHris,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _updateInquiries(data); // Update inquiries only if changed
    } else {
      print('Failed to load confirmed data: ${response.body}');
    }
  }

  void _showNoDataWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No inquiries found for this user.'),
        backgroundColor: const Color.fromARGB(
            255, 227, 145, 4), // Set the color to orange for warning
        duration: Duration(seconds: 3), // Show the SnackBar for 3 seconds
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: widget.tabName == 'Ongoing'
                ? OngoingTable(
                    inquiries: inquiries,
                    refreshData: fetchOngoingInquiries,
                  )
                : widget.tabName == 'Prospect'
                    ? ProspectTable(
                        inquiries: inquiries,
                        refreshData: fetchProspectInquiries,
                      )
                    : widget.tabName == 'NonProspect'
                        ? NonProspectTable(
                            inquiries: inquiries,
                            refreshData: fetchNonProspectInquiries,
                          )
                        : widget.tabName == 'Confirmed'
                            ? ConfirmedTable(
                                inquiries: inquiries,
                                refreshData: fetchConfirmedInquiries,
                              )
                            : Container(),
          ),
        ],
      ),
    );
  }
}
