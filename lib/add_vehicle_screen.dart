import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  Future<void> addVehicle() async {
    final response = await http.post(
      Uri.parse('http://192.168.153.127/service/vehicles.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'vehicle_name': vehicleNameController.text,
        'model': modelController.text,
        'year': int.parse(yearController.text),
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, 'Vehicle added successfully');
    } else {
      throw Exception('Failed to add vehicle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
        backgroundColor: Colors.teal, // Set background color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.add_box,
                  size: 100,
                  color: Colors.teal,
                ),
                SizedBox(height: 16),
                Text(
                  'Add a New Vehicle',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                TextField(
                  controller: vehicleNameController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Name',
                    prefixIcon: Icon(Icons.directions_car, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: modelController,
                  decoration: InputDecoration(
                    labelText: 'Model',
                    prefixIcon: Icon(Icons.model_training, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: yearController,
                  decoration: InputDecoration(
                    labelText: 'Year',
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    addVehicle();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make the text bold
                      color: Colors.black, // Set the text color to dark
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Set button color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
