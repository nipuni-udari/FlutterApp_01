import 'package:flutter/material.dart';
import 'package:newapp/screens/Inquries/components/remark_modal.dart';

class OngoingTable extends StatefulWidget {
  final List<dynamic> inquiries;

  const OngoingTable({Key? key, required this.inquiries}) : super(key: key);

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
                  ],
                  source: _OngoingTableDataSource(widget.inquiries, context),
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

  _OngoingTableDataSource(this.inquiries, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= inquiries.length) return null;

    final inquiry = inquiries[index];
    return DataRow(
      cells: [
        DataCell(Text(inquiry['inquiry_id']?.toString() ?? '')),
        DataCell(Text(inquiry['customer_name'] ?? '')),
        DataCell(
          ElevatedButton(
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
          // Handle the updated values
          print('Selected Date: $selectedDate, Remarks: $remarks');
          print('Inquiry ID: ${inquiry['inquiry_id']}'); // For debugging
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
