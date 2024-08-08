import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Information'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Additional action or information can be added here
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Company Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.business, color: Colors.deepPurple, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Welcome to our service! We are committed to providing the best quality service. Our mission is to ensure customer satisfaction with every interaction.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.deepPurple, size: 30), // Replaced with Icons.star
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Mission: To deliver exceptional service that exceeds expectations and fosters long-term relationships.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.deepPurple, size: 30), // Replaced with Icons.visibility
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Vision: To be the most trusted and innovative service provider in the industry.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.deepPurple, size: 30), // Replaced with Icons.check_circle
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Values: Integrity, Excellence, Customer-Centricity, Innovation.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
