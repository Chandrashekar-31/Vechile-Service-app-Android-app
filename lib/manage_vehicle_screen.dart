import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_vehicle_screen.dart';

class ManageVehicleScreen extends StatefulWidget {
  @override
  _ManageVehicleScreenState createState() => _ManageVehicleScreenState();
}

class _ManageVehicleScreenState extends State<ManageVehicleScreen> {
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    final response = await http.get(Uri.parse('http://192.168.153.127/service/vehicles.php'));

    if (response.statusCode == 200) {
      setState(() {
        vehicles = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<void> deleteVehicle(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.153.127/service/vehicles.php?id=$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      fetchVehicles(); // Refresh the list after deletion
    } else {
      throw Exception('Failed to delete vehicle');
    }
  }

  Future<void> editVehicle(int id, String vehicleName, String model, int year) async {
    final response = await http.put(
      Uri.parse('http://192.168.153.127/service/vehicles.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'vehicle_name': vehicleName,
        'model': model,
        'year': year,
      }),
    );

    if (response.statusCode == 200) {
      fetchVehicles(); // Refresh the list after editing
    } else {
      throw Exception('Failed to update vehicle');
    }
  }

  void showEditDialog(Map<String, dynamic> vehicle) {
    TextEditingController vehicleNameController = TextEditingController(text: vehicle['vehicle_name']);
    TextEditingController modelController = TextEditingController(text: vehicle['model']);
    TextEditingController yearController = TextEditingController(text: vehicle['year'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Vehicle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: vehicleNameController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: modelController,
                  decoration: InputDecoration(
                    labelText: 'Model',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.model_training),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: yearController,
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
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
                editVehicle(
                  vehicle['id'] is String ? int.parse(vehicle['id']) : vehicle['id'],
                  vehicleNameController.text,
                  modelController.text,
                  int.parse(yearController.text),
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
        title: Text('Manage Vehicles'),
        backgroundColor: Colors.teal, // Set background color
      ),
      backgroundColor: Colors.grey[100], // Set background color
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: vehicles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(Icons.directions_car, color: Colors.teal, size: 40),
                title: Text(
                  vehicle['vehicle_name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${vehicle['model']} - ${vehicle['year']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        showEditDialog(vehicle);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete this vehicle?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteVehicle(vehicle['id'] is String ? int.parse(vehicle['id']) : vehicle['id']);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehicleScreen()),
          ).then((result) {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
              fetchVehicles(); // Refresh the list after adding a vehicle
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal, // Set background color
      ),
    );
  }
}
