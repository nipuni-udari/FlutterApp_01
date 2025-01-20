import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/screens/Inquries/components/Tables/confirm_table.dart';
import 'dart:convert';
import 'Tables/ongoing_table.dart';
import 'Tables/prospect_table.dart';
import 'Tables/nonProspect_table.dart';

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
    if (widget.tabName == 'Ongoing') {
      fetchOngoingInquiries();
    } else if (widget.tabName == 'Prospect') {
      fetchProspectInquiries();
    } else if (widget.tabName == 'NonProspect') {
      fetchNonProspectInquiries();
    } else if (widget.tabName == 'Confirmed') {
      fetchConfirmedInquiries();
    }
  }

  Future<void> fetchOngoingInquiries() async {
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_ongoing_inquiries.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        inquiries = json.decode(response.body);
      });
    } else {
      print('Failed to load ongoing data');
    }
  }

  Future<void> fetchProspectInquiries() async {
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_prospect_inquiries.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        inquiries = json.decode(response.body);
      });
    } else {
      print('Failed to load prospect data');
    }
  }

  Future<void> fetchNonProspectInquiries() async {
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_NonProspect_inquiries.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        inquiries = json.decode(response.body);
      });
    } else {
      print('Failed to load non prospect data');
    }
  }

  Future<void> fetchConfirmedInquiries() async {
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/get_confirmed_inquiries.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        inquiries = json.decode(response.body);
      });
    } else {
      print('Failed to load confirmed data');
    }
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
                    refreshData:
                        fetchOngoingInquiries, // Pass the refresh function
                  )
                : widget.tabName == 'Prospect'
                    ? ProspectTable(
                        inquiries: inquiries,
                        refreshData:
                            fetchProspectInquiries, // Pass the refresh function
                      )
                    : widget.tabName == 'NonProspect'
                        ? NonProspectTable(inquiries: inquiries)
                        : widget.tabName == 'Confirmed'
                            ? ConfirmedTable(inquiries: inquiries)
                            : Container(),
          ),
        ],
      ),
    );
  }
}
