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

  String getMonthAbbreviation(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return (month > 0 && month <= 12) ? monthNames[month - 1] : '';
  }

  Widget _buildDateBadge(String dateString) {
    final DateTime date = DateTime.tryParse(dateString) ?? DateTime.now();
    final String month = getMonthAbbreviation(date.month);
    final String day = date.day.toString();

    return Container(
      width: 50.0, // Reduced width
      height: 50.0, // Reduced height
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF674AEF), Color(0xFF8A6EFF)],
        ),
        borderRadius: BorderRadius.circular(6.0), // Reduced corner radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0, // Smaller font size
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0, // Smaller font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height * 0.7, // Limit the dialog height
        child: Column(
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Name
                      Text(
                        'Customer: ${widget.customerName}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Action Date Input
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

                      // Remarks Text Area
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

                      // Previous Remarks Section
                      const Text(
                        'Previous Remarks:',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),

                      _remarksList.isEmpty
                          ? const Text('No remarks available.')
                          : SizedBox(
                              height:
                                  200.0, // Limit the height of the remarks list
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _remarksList.length,
                                itemBuilder: (context, index) {
                                  final remark = _remarksList[index];
                                  final String remarkUpdateDate =
                                      remark['remark_update_date'] ?? '';
                                  final String remarks =
                                      remark['remarks'] ?? 'No remarks';
                                  final String actionDate =
                                      remark['action_date'] ?? '';

                                  return ListTile(
                                    leading: _buildDateBadge(actionDate),
                                    title: Text(
                                      remarks,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5.0),
                                        Text(
                                          'Remark Update Date: $remarkUpdateDate',
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),

            // Buttons Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
