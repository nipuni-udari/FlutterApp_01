import 'package:flutter/material.dart';
import 'package:newapp/screens/Inquries/components/remark_modal.dart';
import 'package:newapp/screens/Inquries/components/view_modal.dart';

class OngoingTable extends StatefulWidget {
  final List<dynamic> inquiries;
  final Function() refreshData;

  const OngoingTable(
      {Key? key, required this.inquiries, required this.refreshData})
      : super(key: key);

  @override
  _OngoingTableState createState() => _OngoingTableState();
}

class _OngoingTableState extends State<OngoingTable> {
  int _rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    return widget.inquiries.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                PaginatedDataTable(
                  header: const Text('Ongoing Inquiries'),
                  columns: const [
                    DataColumn(label: Text('Inquiry ID')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Action Date')),
                    DataColumn(label: Text('Products')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Days')),
                    DataColumn(label: Text('Actions')), // New column
                  ],
                  source: _OngoingTableDataSource(
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

class _OngoingTableDataSource extends DataTableSource {
  final List<dynamic> inquiries;
  final BuildContext context;
  final Function() refreshData;

  _OngoingTableDataSource(this.inquiries, this.context, this.refreshData);

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
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
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
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'View') {
                _showViewModal(
                    inquiry); // Update this line to call showViewModal
              } else if (value == 'Change Status') {
                _showChangeStatusDialog(inquiry);
              } else if (value == 'Delete') {
                _showDeleteDialog(inquiry);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'View',
                child: Text('View'),
              ),
              const PopupMenuItem(
                value: 'Change Status',
                child: Text('Change Status'),
              ),
              const PopupMenuItem(
                value: 'Delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
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
          inquiry['action_date'] = selectedDate;
          refreshData();
          Navigator.pop(context);
        },
      ),
    );
  }

  // Updated method to show the View modal
  void _showViewModal(dynamic inquiry) {
    showViewModal(
      context: context,
      inquiryId: inquiry['inquiry_id'] ?? '',
      customerCompanyName: inquiry['customer_name'] ?? 'Unknown',
    );
  }

  void _showChangeStatusDialog(dynamic inquiry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Status'),
        content: DropdownButton<String>(
          value: inquiry['status'] ?? 'Pending',
          items: ['Pending', 'In Progress', 'Completed']
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
              .toList(),
          onChanged: (value) {
            inquiry['status'] = value!;
            refreshData();
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(dynamic inquiry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Inquiry'),
        content: Text(
            'Are you sure you want to delete inquiry ${inquiry['inquiry_id']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              inquiries.remove(inquiry);
              refreshData();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
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
