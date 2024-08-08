import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageCustomersScreen extends StatefulWidget {
  @override
  _ManageCustomersScreenState createState() => _ManageCustomersScreenState();
}

class _ManageCustomersScreenState extends State<ManageCustomersScreen> {
  List customers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.153.127/service/get_customers.php'));

      if (response.statusCode == 200) {
        setState(() {
          customers = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.153.127/service/delete_customer.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'customerId': id}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          fetchCustomers(); // Refresh the list after deletion
        } else {
          print('Failed to delete customer: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to delete customer');
      }
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }

  Future<void> editCustomer(int id, String username, String email, String phone) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.153.127/service/edit_customer.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'username': username,
          'email': email,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        fetchCustomers(); // Refresh the list after editing
      } else {
        print('Failed to update customer: ${response.body}');
        throw Exception('Failed to update customer');
      }
    } catch (e) {
      print('Error editing customer: $e');
    }
  }

  void showEditDialog(Map customer) {
    TextEditingController usernameController = TextEditingController(text: customer['username']);
    TextEditingController emailController = TextEditingController(text: customer['email']);
    TextEditingController phoneController = TextEditingController(text: customer['phone']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await editCustomer(
                  customer['id'] is String ? int.parse(customer['id']) : customer['id'],
                  usernameController.text,
                  emailController.text,
                  phoneController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Customers'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: FadeTransition(
                opacity: AlwaysStoppedAnimation(1.0),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.teal),
                  title: Text(customer['username'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(customer['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          showEditDialog(customer);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this customer?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await deleteCustomer(customer['id'] is String ? int.parse(customer['id']) : customer['id']);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add customer screen
          // For example:
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AddCustomerScreen()),
          // );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
