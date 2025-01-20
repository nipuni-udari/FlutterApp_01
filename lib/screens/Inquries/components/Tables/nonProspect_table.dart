import 'package:flutter/material.dart';
import 'package:newapp/screens/Inquries/components/remark_modal.dart';

class NonProspectTable extends StatefulWidget {
  final List<dynamic> inquiries;
  final Function() refreshData; // Add this line to pass a callback

  const NonProspectTable(
      {Key? key, required this.inquiries, required this.refreshData})
      : super(key: key);

  @override
  _NonProspectTableState createState() => _NonProspectTableState();
}

class _NonProspectTableState extends State<NonProspectTable> {
  int _rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    return widget.inquiries.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                PaginatedDataTable(
                  header: const Text('NonProspect Inquiries'),
                  columns: const [
                    DataColumn(label: Text('Inquiry ID')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Action Date')),
                    DataColumn(label: Text('Products')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Days')),
                  ],
                  source: _NonProspectTableDataSource(
                      widget.inquiries, context, widget.refreshData),
                  rowsPerPage: _rowsPerPage,
                  columnSpacing: 20.0,
                  showCheckboxColumn: false,
                  onPageChanged: (int rowIndex) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      const Text('Rows per page:'),
                      DropdownButton<int>(
                        value: _rowsPerPage,
                        items: [5, 10, 20].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _rowsPerPage = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class _NonProspectTableDataSource extends DataTableSource {
  final List<dynamic> inquiries;
  final BuildContext context;
  final Function() refreshData; // Store the refreshData callback

  _NonProspectTableDataSource(this.inquiries, this.context, this.refreshData);

  @override
  DataRow? getRow(int index) {
    if (index >= inquiries.length) return null;

    final inquiry = inquiries[index];
    return DataRow(
      cells: [
        DataCell(Text(inquiry['inquiry_id']?.toString() ?? '')),
        DataCell(Text(inquiry['customer_name'] ?? '')),
        DataCell(
          inquiry['action_date'] != null && inquiry['action_date']!.isNotEmpty
              ? GestureDetector(
                  onTap: () => _showRemarkModal(inquiry),
                  child: Text(
                    inquiry['action_date']!,
                    style: TextStyle(
                      color: Colors
                          .blue, // Change the color to indicate it's clickable
                      decoration: TextDecoration
                          .underline, // Optional: Add underline for emphasis
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () => _showRemarkModal(inquiry),
                  child: const Text('Add Remark'),
                ),
        ),
        DataCell(Text(inquiry['products']?.toString() ?? '')),
        DataCell(Text(inquiry['amount']?.toString() ?? '')),
        DataCell(Text(inquiry['days']?.toString() ?? '')),
      ],
    );
  }

  void _showRemarkModal(dynamic inquiry) {
    showDialog(
      context: context,
      builder: (context) => RemarkModal(
        customerName: inquiry['customer_name'] ?? 'Unknown',
        inquiryId: inquiry['inquiry_id'] ?? 'Unknown',
        actionDate: inquiry['action_date'] ?? '',
        onSubmit: (selectedDate, remarks) {
          // Update the inquiry with the new action date
          inquiry['action_date'] = selectedDate;

          // Call the refreshData function to refresh the table
          refreshData(); // This will trigger the data refresh in the parent widget

          // Close the modal
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => inquiries.length;

  @override
  int get selectedRowCount => 0;
}
