import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool isLoading = false;

  Future<void> addService(String serviceName, String description, double price) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.153.127/service/services.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_name': serviceName,
          'description': description,
          'price': price,
        }),
      );

      final responseBody = response.body;
      print('Server response: $responseBody'); // Debugging: print the response

      if (response.statusCode == 200) {
        try {
          final result = json.decode(responseBody);
          if (result['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Service added successfully')),
            );
            Navigator.pushNamedAndRemoveUntil(context, '/adminDashboard', (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Unknown error')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid response format: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add service: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service'),
        backgroundColor: Colors.deepPurple, // AppBar background color
      ),
      body: Container(
        color: Colors.grey[200], // Background color for the whole screen
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: serviceNameController,
              decoration: InputDecoration(
                labelText: 'Service Name',
                prefixIcon: Icon(Icons.build, color: Colors.deepPurple), // Icon for the service name field
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description, color: Colors.deepPurple), // Icon for the description field
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                prefixIcon: Icon(Icons.monetization_on, color: Colors.deepPurple), // Icon for the price field
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : AnimatedButton(
              onPressed: () {
                final serviceName = serviceNameController.text;
                final description = descriptionController.text;
                final price = double.tryParse(priceController.text);

                if (serviceName.isEmpty || description.isEmpty || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields with valid data')),
                  );
                  return;
                }

                addService(serviceName, description, price);
              },
              child: Text(
                'Add Service',
                style: TextStyle(color: Colors.black), // Dark text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedButton({required this.onPressed, required this.child});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: () {
          _controller.forward().then((_) => _controller.reverse());
          widget.onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, // Button color
          padding: EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
