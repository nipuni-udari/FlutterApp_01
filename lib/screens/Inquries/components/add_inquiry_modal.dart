import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:newapp/user_provider.dart';
import 'package:newapp/screens/Inquries/components/add_customer_modal.dart';

class AddInquiryModal extends StatefulWidget {
  const AddInquiryModal({Key? key}) : super(key: key);

  @override
  State<AddInquiryModal> createState() => _AddInquiryModalState();
}

class _AddInquiryModalState extends State<AddInquiryModal> {
  bool isCustomerSelected = false;
  List<Map<String, dynamic>> productList = [];
  List<dynamic> refeProductList = [];
  String? refNo;
  String? selectedProduct;
  List<String> customerList = [];
  String? selectedCustomer;
  TextEditingController quantityController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  List<Map<String, dynamic>> addedProducts = [];
  TextEditingController customerSearchController = TextEditingController();
  Double? productTotal;
  int? insertedId;

  String? ProductQty;
  String? CompanyName;
  String? ProductName;

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
          refNo = response.body.trim() +
              Provider.of<UserProvider>(context, listen: false).userHris;
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
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> data = responseJson['data'];

        setState(() {
          customerList = data.map((customer) {
            return '${customer['customer_id']} - ${customer['customer_company_name']} - ${customer['customer_address']}';
          }).toList();
        });
      } else {
        print('Failed to load customers');
      }
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  void addProductToList() async {
    final userHris = Provider.of<UserProvider>(context, listen: false).userHris;

    if (selectedCustomer == null || selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a customer and a product.')),
      );
      return;
    }

    // Show confirmation dialog
    final shouldAddProduct = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Add Product'),
          content: const Text('Are you sure you want to add this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldAddProduct == false) {
      return; // Exit if the user cancels
    }

    // Proceed to add product
    final selectedCustomerData = customerList.firstWhere(
      (customer) => customer.contains(selectedCustomer as Pattern),
      orElse: () => '',
    );

    final customerName =
        selectedCustomerData.split(' - ')[1]; // Extract customer name

    final selectedProductData = productList.firstWhere(
      (product) => product['id'].toString() == selectedProduct,
      orElse: () => {'name': 'Unknown Product'},
    );

    final productName = selectedProductData['name']; // Extract product name

    final url =
        'https://demo.secretary.lk/electronics_mobile_app/backend/add_inquiry.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'refNo': refNo ?? '',
        'customerId': selectedCustomer,
        'product': selectedProduct,
        'qty': quantityController.text,
        'proValue': amountController.text,
        'userHris': userHris, // Added userHris to the request body
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // print(response.body);
      if (responseData['success'] == 'Product added successfully') {
        setState(() {
          addedProducts.add({
            'customer_company_name': customerName,
            'product_name': productName,
            'product_qty': quantityController.text,
            'total_value': amountController.text,
          });
          // Assign the products array to refeProductList
          // if (responseData['products'] != null) {
          //   refeProductList =
          //       List<Map<String, dynamic>>.from(responseData['products']);
          // }
        });
        print(responseData['products']);
        insertedId = responseData['insertedId'];
        ProductQty = responseData['product_quantity'];
        CompanyName = responseData['Company_name'];
        ProductName = responseData['product_name'];
        // refeProductList.add(responseData['products']);
        refeProductList = [responseData['products']];
        // print(responseData['products']);
        // print(productTotal);
        // Show success alert
        // Assign the products array to refeProductList

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Product added successfully!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // Refresh page by reloading the state
        setState(() {
          // Logic to refresh the page (e.g., re-fetching data or updating UI)
          // selectedCustomer = null;
          selectedProduct = null;
          quantityController.clear();
          amountController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add inquiry. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add inquiry. Please try again.')),
      );
    }
  }

  void productPlaceOrder() async {
    print(insertedId);
    print(jsonEncode(refeProductList));
    final url =
        'https://demo.secretary.lk/electronics_mobile_app/backend/place_order.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'inquiryId': insertedId?.toString() ?? '',
        'CompanyName': CompanyName.toString(),
        'ProductName': ProductName.toString(),
        'ProductQty': ProductQty.toString(),
        'username': Provider.of<UserProvider>(context, listen: false).username,
        'productList': jsonEncode(refeProductList),
        'refNo': refNo ?? '',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(response.body);
      if (responseData['success'] == 'Order placed successfully') {
        // Show success alert
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Order placed successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the success dialog
                    Navigator.of(context).pop(); // Close the AddInquiryModal
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order. Please try again.')),
      );
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
                      fetchCustomerData();
                      return customerList;
                    }

                    final matchingCustomers =
                        customerList.where((String customer) {
                      return customer
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    }).toList();

                    if (matchingCustomers.isEmpty) {
                      fetchCustomerData(searchInput: textEditingValue.text);
                    }

                    return matchingCustomers;
                  },
                  onSelected: (String selectedCustomer) {
                    setState(() {
                      final selectedCustomerData = customerList.firstWhere(
                        (customer) => customer.contains(selectedCustomer),
                        orElse: () => '',
                      );
                      this.selectedCustomer =
                          selectedCustomerData.split(' - ')[0];
                      // Set the flag to true when a customer is selected
                      isCustomerSelected = true;
                    });
                    print(this.selectedCustomer);
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search field row
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Search Customer',
                                  prefixIcon: const Icon(Icons.search,
                                      color: Color(0xFF674AEF)),
                                  suffixIcon: controller.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            controller.clear();
                                            setState(() {
                                              selectedCustomer = null;
                                              isCustomerSelected = false;
                                            });
                                          },
                                        )
                                      : null,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // Add some spacing
                        // Conditionally render the "Add New Customer" button
                        if (!isCustomerSelected)
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddCustomerModal();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                  255, 207, 239, 251), // Background color
                              foregroundColor:
                                  Color(0xFF674AEF), // Text and icon color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8), // Padding
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Fit the content
                              children: const [
                                Icon(Icons.add), // Plus icon
                                SizedBox(
                                    width: 8), // Spacing between icon and text
                                Text(
                                  'Add New Customer',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.6, // Adjust width as needed
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final option = options.elementAt(index);
                              final parts = option.split(' - ');
                              final customerId = parts[0];
                              final companyName = parts[1];
                              final customerAddress = parts[2];

                              return InkWell(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$customerId - $companyName',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        customerAddress,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Product Description'),
                DropdownButtonFormField<String>(
                  value: selectedProduct,
                  items: productList.map((product) {
                    return DropdownMenuItem<String>(
                      value: product['id'].toString(),
                      child: Text(product['name']),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProduct = newValue;
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
                        keyboardType: TextInputType.number,
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
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true), // Add this line
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: addProductToList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 4, 138, 33), // Set the background color
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(color: Colors.white), // White font color
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Product List'),
                if (addedProducts.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text('Customer')),
                        DataColumn(label: Text('Product')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Total Value')),
                      ],
                      rows: addedProducts.map((product) {
                        return DataRow(cells: [
                          DataCell(
                              Text(product['customer_company_name'] ?? '')),
                          DataCell(Text(product['product_name'] ?? '')),
                          DataCell(Text(product['product_qty'] ?? '')),
                          DataCell(Text(product['total_value'] ?? '')),
                        ]);
                      }).toList(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align elements
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
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal when pressed
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
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
          color: const Color(0xFF674AEF),
        ),
      ),
    );
  }

  List<Widget> _buildDialogActions() {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.red, // Text color
        ),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: productPlaceOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF674AEF),
          foregroundColor: Colors.white, // Text color
        ),
        child: const Text('Place Order'),
      ),
    ];
  }
}
