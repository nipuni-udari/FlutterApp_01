import 'package:flutter/material.dart';

class ChangeStatusModal extends StatefulWidget {
  final String inquiryId;
  final String customerName; // Add this parameter
  final Function(String status, DateTime actionDate, String remarks) onSubmit;

  const ChangeStatusModal({
    Key? key,
    required this.inquiryId,
    required this.customerName, // Initialize the parameter
    required this.onSubmit,
  }) : super(key: key);

  @override
  _ChangeStatusModalState createState() => _ChangeStatusModalState();
}

class _ChangeStatusModalState extends State<ChangeStatusModal> {
  final _statusOptions = ['Prospect', 'NonProspect', 'Confirmed'];
  String _selectedStatus = 'Prospect';
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(primaryColor: Color(0xFF674AEF)),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  // Function to show the confirmation dialog
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to update this?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are about to update the status.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF674AEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                widget.onSubmit(
                  _selectedStatus,
                  _selectedDate,
                  _remarksController.text,
                );
              },
              child: Text(
                'Confirm',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Change Status',
        style: TextStyle(
          color: Color(0xFF674AEF),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // Large width
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.customerName}', // Display customer name
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Set text color to green
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _pickDate(context),
                decoration: InputDecoration(
                  labelText: 'Action Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Color(0xFF674AEF),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF674AEF)),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF674AEF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            _showConfirmationDialog(context); // Show confirmation dialog
          },
          child: const Text(
            'Update',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
        ),
      ],
    );
  }
}
