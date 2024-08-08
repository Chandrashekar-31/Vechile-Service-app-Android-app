import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageServiceScreen extends StatefulWidget {
  @override
  _ManageServiceScreenState createState() => _ManageServiceScreenState();
}

class _ManageServiceScreenState extends State<ManageServiceScreen> {
  List services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse('http://192.168.153.127/service/services.php'));

    if (response.statusCode == 200) {
      setState(() {
        services = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<void> deleteService(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.153.127/service/services.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id}),
    );

    if (response.statusCode == 200) {
      fetchServices(); // Refresh the list after deletion
    } else {
      throw Exception('Failed to delete service');
    }
  }

  Future<void> editService(
      int id, String serviceName, String description, double price, String vehicleName) async {
    final response = await http.put(
      Uri.parse('http://192.168.153.127/service/services.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'service_name': serviceName,
        'description': description,
        'price': price,
        'vehicle_name': vehicleName,
      }),
    );

    if (response.statusCode == 200) {
      fetchServices(); // Refresh the list after editing
    } else {
      throw Exception('Failed to update service');
    }
  }

  void showEditDialog(Map service) {
    TextEditingController serviceNameController =
    TextEditingController(text: service['service_name'] ?? '');
    TextEditingController descriptionController =
    TextEditingController(text: service['description'] ?? '');
    TextEditingController priceController =
    TextEditingController(text: service['price']?.toString() ?? '');
    TextEditingController vehicleNameController =
    TextEditingController(text: service['vehicle_name'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Service'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: serviceNameController,
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: vehicleNameController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                editService(
                  service['id'] is String
                      ? int.parse(service['id'])
                      : service['id'],
                  serviceNameController.text,
                  descriptionController.text,
                  double.parse(priceController.text),
                  vehicleNameController.text,
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
        title: Text('Manage Services'),
        backgroundColor: Colors.teal, // Set background color
      ),
      backgroundColor: Colors.grey[200], // Set background color
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: services.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  service['service_name'] ?? 'N/A',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  (service['description'] ?? 'N/A') +
                      ' - ' +
                      (service['vehicle_name'] ?? 'N/A'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        showEditDialog(service);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete this service?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteService(service['id'] is String
                                      ? int.parse(service['id'])
                                      : service['id']);
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
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add service action if needed
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal, // Set background color
      ),
    );
  }
}
