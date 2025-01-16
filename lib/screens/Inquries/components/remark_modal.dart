import 'package:flutter/material.dart';

class RemarkModal extends StatefulWidget {
  final String actionDate;
  final void Function(String selectedDate, String remarks) onSubmit;

  const RemarkModal({
    Key? key,
    required this.actionDate,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Remark',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Action Date',
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
                    color: _selectedDate == null ? Colors.grey : Colors.black,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    widget.onSubmit(
                      _selectedDate ?? '',
                      _remarksController.text,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
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

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }
}
