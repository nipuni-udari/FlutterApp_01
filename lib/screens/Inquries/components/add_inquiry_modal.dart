import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddInquiryModal extends StatefulWidget {
  const AddInquiryModal({Key? key}) : super(key: key);

  @override
  State<AddInquiryModal> createState() => _AddInquiryModalState();
}

class _AddInquiryModalState extends State<AddInquiryModal> {
  List<Map<String, dynamic>> productList = [];
  String? refNo;
  String? selectedProduct;
  List<String> customerList = [];
  String? selectedCustomer;
  TextEditingController quantityController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProductData();
    fetchCustomerData();
    fetchReferenceNumber();
  }

  void fetchReferenceNumber() async {
    const String url =
        'https://demo.secretary.lk/electronics_mobile_app/backend/generate_ref_no.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          refNo = response.body.trim();
        });
      } else {
        print('Failed to fetch reference number');
      }
    } catch (e) {
      print('Error fetching reference number: $e');
    }
  }

  void fetchProductData({String searchInput = ''}) async {
    final String url =
        'https://demo.secretary.lk/electronics_mobile_app/backend/fetch_products.php?searchInput=$searchInput';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          productList = data.map((product) {
            return {
              'id': product['id'],
              'name': product['product_name'],
            };
          }).toList();
        });
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void fetchCustomerData({String searchInput = ''}) async {
    final String url =
        'https://demo.secretary.lk/electronics_mobile_app/backend/fetch_customers.php?searchInput=$searchInput';
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> data = responseJson['data'];
        setState(() {
          customerList = data.map((customer) {
            return '${customer['customer_company_name']} - ${customer['customer_address']}';
          }).toList();
        });
      } else {
        print('Failed to load customers');
      }
    } catch (e) {
      print('Error fetching customers: $e');
    }
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
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }

                    // Check if the customer list contains the input text
                    final matchingCustomers =
                        customerList.where((String customer) {
                      return customer
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    }).toList();

                    // If no matching customers, call fetchCustomerData
                    if (matchingCustomers.isEmpty) {
                      fetchCustomerData(searchInput: textEditingValue.text);
                    }

                    return matchingCustomers;
                  },
                  onSelected: (String selectedCustomer) {
                    setState(() {
                      this.selectedCustomer = selectedCustomer;
                    });
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Search Customer',
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF674AEF)),
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Product Description'),
                DropdownButtonFormField<String>(
                  value:
                      selectedProduct, // This will hold the selected product's ID
                  items: productList.map((product) {
                    return DropdownMenuItem<String>(
                      value: product['id']
                          .toString(), // Store the product ID as value
                      child: Text(product['name']), // Display the product name
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProduct =
                          newValue; // Update selected product's ID
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Product',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Order Information'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          prefixIcon: Icon(Icons.confirmation_number,
                              color: Color(0xFF674AEF)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.attach_money,
                              color: Color(0xFF674AEF)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.add_circle, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Add a New Inquiry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            refNo != null
                ? 'Inquiry No: $refNo'
                : 'Loading reference number...',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF674AEF),
      ),
    );
  }

  List<Widget> _buildDialogActions() {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel', style: TextStyle(color: Colors.red)),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF674AEF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          if (selectedCustomer == null || selectedProduct == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Please select a customer and a product.')),
            );
            return;
          }

          final url =
              'https://demo.secretary.lk/electronics_mobile_app/backend/add_inquiry.php';
          final response = await http.post(
            Uri.parse(url),
            body: {
              'refNo': refNo ?? '',
              'customerId': selectedCustomer, // Ensure this is the correct ID
              'product': selectedProduct,
              'qty':
                  quantityController.text, // Replace with actual quantity input
              'proValue':
                  amountController.text, // Replace with actual amount input
            },
          );
          print(quantityController.text);
          print(selectedCustomer);
          print(refNo);
          print(amountController.text);

          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Inquiry added successfully!')),
            );
            Navigator.of(context).pop(); // Close the modal
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to add inquiry. Please try again.')),
            );
          }
        },
        child: const Text('Add'),
      ),
    ];
  }
}
