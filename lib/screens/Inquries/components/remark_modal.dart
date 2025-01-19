import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemarkModal extends StatefulWidget {
  final String customerName;
  final String actionDate;
  final String inquiryId;
  final void Function(String selectedDate, String remarks) onSubmit;

  const RemarkModal({
    Key? key,
    required this.customerName,
    required this.actionDate,
    required this.inquiryId, // Add this
    required this.onSubmit,
  }) : super(key: key);

  @override
  _RemarkModalState createState() => _RemarkModalState();
}

class _RemarkModalState extends State<RemarkModal> {
  final TextEditingController _remarksController = TextEditingController();
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.actionDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient header
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF674AEF), Color(0xFF8A6EFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Add Remark',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Customer: ${widget.customerName}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 18, 89, 4),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Action Date',
                      labelStyle: TextStyle(color: Color(0xFF674AEF)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                    ),
                    child: Text(
                      _selectedDate ?? 'Select Date',
                      style: TextStyle(
                        color:
                            _selectedDate == null ? Colors.grey : Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _remarksController,
                  decoration: InputDecoration(
                    labelText: 'Remarks',
                    labelStyle: TextStyle(color: Color(0xFF674AEF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20.0),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: const Color(0xFF674AEF),
                      ),
                      onPressed: _showConfirmationDialog,
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.actionDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _submitRemark() async {
    if (_selectedDate == null || _remarksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide all required fields.'),
        ),
      );
      return;
    }

    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/insert_remark.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'inquiryId': widget.inquiryId, // Use inquiryId here
        'update_action_date': _selectedDate,
        'inq_update_remark': _remarksController.text,
      }),
    );
    //debugPrint(response.body);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      // Display success alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Remark added successfully!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success alert
                Navigator.of(context).pop(); // Close the modal box
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Call the onSubmit callback
      widget.onSubmit(_selectedDate!, _remarksController.text);
    } else {
      // Display failure message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit remark.')),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text(
          'Are you sure you want to add remarks for ${widget.customerName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitRemark();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }
}
