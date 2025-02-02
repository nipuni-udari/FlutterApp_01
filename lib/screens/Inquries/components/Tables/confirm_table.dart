import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newapp/screens/Inquries/components/change_status_modal.dart';
import 'package:newapp/screens/Inquries/components/remark_modal.dart';
import 'package:newapp/screens/Inquries/components/view_modal.dart';
import 'package:http/http.dart' as http;

class ConfirmedTable extends StatefulWidget {
  final List<dynamic> inquiries;
  final Future<void> Function() refreshData;

  const ConfirmedTable({
    Key? key,
    required this.inquiries,
    required this.refreshData,
  }) : super(key: key);

  @override
  _ConfirmedTableState createState() => _ConfirmedTableState();
}

class _ConfirmedTableState extends State<ConfirmedTable> {
  int _rowsPerPage = 5;
  @override
  @override
  Widget build(BuildContext context) {
    return widget.inquiries.isEmpty
        ? const Center(
            child: SpinKitChasingDots(color: Color.fromARGB(255, 162, 63, 255)))
        : RefreshIndicator(
            onRefresh: widget.refreshData,
            child: ListView(
              children: [
                PaginatedDataTable(
                  header: Text('Confirmed Inquiries',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 7, 141, 36))),
                  columns: const [
                    DataColumn(label: Text('Inquiry ID')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Action Date')),
                    DataColumn(label: Text('Products')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Days')),
                    DataColumn(label: Text('Actions')),
                  ],
                  source: _ConfirmedTableDataSource(
                    widget.inquiries,
                    context,
                    widget.refreshData,
                  ),
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

class _ConfirmedTableDataSource extends DataTableSource {
  final List<dynamic> inquiries;
  final BuildContext context;
  final Future<void> Function() refreshData;

  _ConfirmedTableDataSource(this.inquiries, this.context, this.refreshData);

  @override
  DataRow? getRow(int index) {
    if (index >= inquiries.length) return null;

    final inquiry = inquiries[index];
    final String? actionDate = inquiry['action_date'];
    final String today = DateTime.now()
        .toIso8601String()
        .substring(0, 10); // Today's date in 'YYYY-MM-DD' format

    return DataRow(
      cells: [
        DataCell(Text(inquiry['inquiry_id']?.toString() ?? '')),
        DataCell(Text(inquiry['customer_name'] ?? '')),
        DataCell(
          Row(
            children: [
              if (actionDate != null && actionDate.isNotEmpty)
                GestureDetector(
                  onTap: () => _showRemarkModal(inquiry),
                  child: Text(
                    actionDate,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () => _showRemarkModal(inquiry),
                  child: const Text('Add Remark'),
                ),
              if (actionDate != null &&
                  actionDate.isNotEmpty &&
                  actionDate == today)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Remark',
                  onPressed: () => _showDeleteRemarkDialog(inquiry),
                ),
            ],
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
                _showViewModal(inquiry);
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
      barrierDismissible: false,
      builder: (context) => ChangeStatusModal(
        inquiryId: inquiry['inquiry_id'] ?? 'Unknown',
        customerName: inquiry['customer_name'] ?? 'Unknown',
        onSubmit: (status, actionDate, remarks) async {
          try {
            final response = await http.post(
              Uri.parse(
                  'https://demo.secretary.lk/electronics_mobile_app/backend/change_status.php'),
              body: {
                'inquiry_id': inquiry['inquiry_id'],
                'status': status,
                'action_date': actionDate.toIso8601String(),
                'remarks': remarks,
                'customer_name': inquiry['customer_name'],
              },
            );

            if (response.statusCode == 200) {
              inquiry['status'] = status;
              inquiry['action_date'] = actionDate.toIso8601String();
              refreshData();

              // Close the modal first
              Navigator.of(context).pop(); // Closes the ChangeStatusModal

              // Show success alert
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Status updated successfully!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the success dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              throw Exception('Failed to update status');
            }
          } catch (e) {
            // Show error alert
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('Error: ${e.toString()}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the error dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(dynamic inquiry) {
    final scaffoldContext = context; // Save the current context
    showDialog(
      context: scaffoldContext,
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
            onPressed: () async {
              Navigator.pop(context); // Close the confirmation dialog

              // Perform the delete operation
              final response = await http.post(
                Uri.parse(
                    'https://demo.secretary.lk/electronics_mobile_app/backend/delete_inquiry.php'),
                body: {'inquiryId': inquiry['inquiry_id']},
              );

              final responseData = jsonDecode(response.body);

              if (responseData['status'] == 'error') {
                // Show error alert
                showDialog(
                  context: scaffoldContext, // Use the saved context
                  builder: (context) => AlertDialog(
                    title: const Text('Cannot Delete'),
                    content: Text(responseData['message']),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else if (responseData['status'] == 'success') {
                // Remove inquiry locally and refresh data
                inquiries.remove(inquiry);
                await refreshData();

                // Show success alert
                showDialog(
                  context: scaffoldContext, // Use the saved context
                  builder: (context) => AlertDialog(
                    title: const Text('Success'),
                    content: Text(responseData['message']),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                // Handle unexpected response
                showDialog(
                  context: scaffoldContext, // Use the saved context
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('An unexpected error occurred.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteRemarkDialog(dynamic inquiry) {
    final todayDate = DateTime.now(); // Get current date

    // Check if the action_date matches today
    if (inquiry['action_date'] != null) {
      final actionDate = DateTime.parse(inquiry['action_date']);
      if (actionDate.year == todayDate.year &&
          actionDate.month == todayDate.month &&
          actionDate.day == todayDate.day) {
        // Proceed with deletion
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Remark'),
            content: Text(
                'Are you sure you want to delete the remark for inquiry ${inquiry['inquiry_id']}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the dialog
                  try {
                    // Send delete request to backend
                    final response = await http.post(
                      Uri.parse(
                          'https://demo.secretary.lk/electronics_mobile_app/backend/delete_remark.php'),
                      body: {
                        'inquiry_id': inquiry['inquiry_id'],
                        'action_date': inquiry['action_date'], // Send date
                      },
                    );

                    final responseData = jsonDecode(response.body);

                    if (responseData['status'] == 'success') {
                      // Update local inquiry data
                      inquiry['remarks'] = null;
                      await refreshData();

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Success'),
                          content: Text(responseData['message']),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      throw Exception(responseData['message']);
                    }
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content:
                            Text('Failed to delete remark: ${e.toString()}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      } else {
        // Show an error if action_date is not today
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Action'),
            content: const Text(
                'Remarks can only be deleted if the action date is today.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => inquiries.length;

  @override
  int get selectedRowCount => 0;
}
