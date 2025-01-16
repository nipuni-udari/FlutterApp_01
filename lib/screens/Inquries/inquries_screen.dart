import 'package:flutter/material.dart';
import 'components/tab_view.dart';
import 'components/add_inquiry_modal.dart';

class InquriesScreen extends StatelessWidget {
  const InquriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Inquiries',
            style: TextStyle(
                color: Colors.white), // Set the title text color to white
          ),
          backgroundColor: const Color(0xFF674AEF), // Set the theme color
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ongoing'),
              Tab(text: 'Prospect'),
              Tab(text: 'NonProspect'),
              Tab(text: 'Confirmed'),
            ],
            labelColor: Color.fromARGB(255, 144, 250,
                218), // Set the label text color of the tabs to white
            unselectedLabelColor: Colors
                .white70, // Set the unselected tab text color to white with some opacity
          ),
        ),
        body: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8E8E8),
                Color(0xFFF9F9F9)
              ], // Add a light gradient background for the page
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
          backgroundColor: const Color(0xFF674AEF), // Set the theme color
          icon: const Icon(Icons.add,
              color: Colors.white), // Set the icon color to white
          label: const Text(
            'Add Inquiry',
            style:
                TextStyle(color: Colors.white), // Set the text color to white
          ),
        ),
      ),
    );
  }
}
