import 'package:flutter/material.dart';

class ChangeStatusModal extends StatefulWidget {
  final String inquiryId;
  final String customerName;
  final Function(String status, DateTime actionDate, String remarks) onSubmit;

  const ChangeStatusModal({
    Key? key,
    required this.inquiryId,
    required this.customerName,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _ChangeStatusModalState createState() => _ChangeStatusModalState();
}

class _ChangeStatusModalState extends State<ChangeStatusModal> {
  final _statusOptions = ['PROSPECT', 'NON_PROSPECT', 'CONFIRMED'];
  String _selectedStatus = 'PROSPECT';
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
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      title: _buildDialogTitle(),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Customer Information'),
                Text(
                  '${widget.customerName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Status'),
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
                  decoration: const InputDecoration(
                    labelText: 'Select Status',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Action Date'),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _pickDate(context),
                  decoration: InputDecoration(
                    labelText: 'Action Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF674AEF),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Remarks'),
                TextFormField(
                  controller: _remarksController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Enter remarks',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: _buildDialogActions(),
    );
  }

  Widget _buildDialogTitle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF674AEF),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.change_circle, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Change Status',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Color(0xFF674AEF),
        ),
      ),
    );
  }

  List<Widget> _buildDialogActions() {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'Cancel',
          style: TextStyle(color: Color(0xFF674AEF)),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          _showConfirmationDialog(context); // Show confirmation dialog
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF674AEF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Update',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ];
  }
}
