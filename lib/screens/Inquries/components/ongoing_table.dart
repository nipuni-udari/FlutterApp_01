import 'package:flutter/material.dart';

class OngoingTable extends StatelessWidget {
  final List<dynamic> inquiries;

  const OngoingTable({Key? key, required this.inquiries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return inquiries.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: PaginatedDataTable(
              header: const Text('Ongoing Inquiries'),
              columns: const [
                DataColumn(label: Text('Customer Name')),
                DataColumn(label: Text('Action Date')),
                DataColumn(label: Text('Products')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Days')),
              ],
              source: _OngoingTableDataSource(inquiries),
              rowsPerPage: 10, // Number of rows per page
              columnSpacing: 20.0,
              showCheckboxColumn: false,
            ),
          );
  }
}

class _OngoingTableDataSource extends DataTableSource {
  final List<dynamic> inquiries;

  _OngoingTableDataSource(this.inquiries);

  @override
  DataRow? getRow(int index) {
    if (index >= inquiries.length) return null;

    final inquiry = inquiries[index];
    return DataRow(
      cells: [
        DataCell(Text(inquiry['customer_name'] ?? '')),
        DataCell(Text(inquiry['action_date'] ?? '')),
        DataCell(Text(inquiry['products']?.toString() ?? '')),
        DataCell(Text(inquiry['amount']?.toString() ?? '')),
        DataCell(Text(inquiry['days']?.toString() ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => inquiries.length;

  @override
  int get selectedRowCount => 0;
}
