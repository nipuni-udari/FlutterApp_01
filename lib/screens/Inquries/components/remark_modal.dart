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
    required this.inquiryId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _RemarkModalState createState() => _RemarkModalState();
}

class _RemarkModalState extends State<RemarkModal> {
  final TextEditingController _remarksController = TextEditingController();
  String? _selectedDate;
  List<dynamic> _remarksList = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.actionDate;
    _fetchRemarks();
  }

  Future<void> _fetchRemarks() async {
    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/insert_remark.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'inquiryId': widget.inquiryId}),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _remarksList = result['remarks'] ?? [];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch remarks.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF674AEF), Color(0xFF8A6EFF)],
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

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Customer: ${widget.customerName}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Display Remarks
                  const Text(
                    'Previous Remarks:',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  _remarksList.isEmpty
                      ? const Text('No remarks available.')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _remarksList.length,
                          itemBuilder: (context, index) {
                            final remark = _remarksList[index];
                            return ListTile(
                              title: Text(remark['remarks'] ?? 'No remark'),
                              subtitle: Text(
                                  'Date: ${remark['remark_update_date'] ?? ''}'),
                            );
                          },
                        ),
                  const SizedBox(height: 20.0),

                  // Input Fields
                  GestureDetector(
                    onTap: _selectDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Action Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(_selectedDate ?? 'Select Date'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _remarksController,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: _submitRemark,
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
        const SnackBar(content: Text('Please provide all required fields.')),
      );
      return;
    }

    final url = Uri.parse(
        'https://demo.secretary.lk/electronics_mobile_app/backend/insert_remark.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'inquiryId': widget.inquiryId,
        'update_action_date': _selectedDate,
        'inq_update_remark': _remarksController.text,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      await _fetchRemarks();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit remark.')),
      );
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }
}
