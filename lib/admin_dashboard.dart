import 'package:flutter/material.dart';
import 'ViewFeedbackScreen.dart';
import 'add_service_screen.dart';
import 'login.dart';
import 'manage_customers_screen.dart';
import 'manage_service_screen.dart';
import 'manage_vehicle_screen.dart';
import 'view_appointments_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title, Widget destination, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple, // Background color for AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100], // Background color for the whole screen
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome, Admin!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple, // Color for welcome text
                  ),
                ),
                SizedBox(height: 20),
                _buildDashboardButton(
                  context,
                  'Add Service',
                  AddServiceScreen(),
                  Icons.add_circle_outline,
                  Colors.deepPurple,
                ),
                SizedBox(height: 16),
                _buildDashboardButton(
                  context,
                  'Manage Service',
                  ManageServiceScreen(),
                  Icons.settings,
                  Colors.orange,
                ),
                SizedBox(height: 16),
                _buildDashboardButton(
                  context,
                  'Manage Vehicles',
                  ManageVehicleScreen(),
                  Icons.directions_car,
                  Colors.teal,
                ),
                SizedBox(height: 16),
                _buildDashboardButton(
                  context,
                  'Manage Customers',
                  ManageCustomersScreen(),
                  Icons.people,
                  Colors.red,
                ),
                SizedBox(height: 16),
                _buildDashboardButton(
                  context,
                  'View Appointments',
                  ViewAppointmentsScreen(),
                  Icons.calendar_today,
                  Colors.blue,
                ),
                SizedBox(height: 16),
                _buildDashboardButton(
                  context,
                  'View Feedback',
                  ViewFeedbackScreen(),
                  Icons.feedback,
                  Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
