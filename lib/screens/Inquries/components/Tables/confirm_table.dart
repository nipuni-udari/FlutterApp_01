import 'package:flutter/material.dart';

class ConfirmedTable extends StatefulWidget {
  final List<dynamic> inquiries;

  const ConfirmedTable({Key? key, required this.inquiries}) : super(key: key);

  @override
  _ConfirmedTableState createState() => _ConfirmedTableState();
}

class _ConfirmedTableState extends State<ConfirmedTable> {
  int _rowsPerPage = 5; // Default rows per page

  @override
  Widget build(BuildContext context) {
    return widget.inquiries.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                PaginatedDataTable(
                  header: const Text('confirmed Inquiries'),
                  columns: const [
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Action Date')),
                    DataColumn(label: Text('Products')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Days')),
                  ],
                  source: _ConfirmedTableDataSource(widget.inquiries),
                  rowsPerPage: _rowsPerPage, // Use the dynamic rows per page
                  columnSpacing: 20.0,
                  showCheckboxColumn: false,
                  onPageChanged: (int rowIndex) {},
                ),
                // Custom pagination at the bottom left
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

  _ConfirmedTableDataSource(this.inquiries);

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
