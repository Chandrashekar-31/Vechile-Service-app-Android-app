import 'package:flutter/material.dart';
import 'login.dart'; // Import the Login screen
import 'signup.dart'; // Import the Signup screen
import 'user_dashboard.dart'; // Import the User Dashboard screen
import 'admin_login.dart'; // Import the Admin Login screen
import 'admin_dashboard.dart'; // Import the Admin Dashboard screen


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Set initial route to login
      routes: {
        '/login': (context) => LoginScreen(), // Define the route for Login
        '/signup': (context) => Signup(), // Define the route for Signup
        '/user_dashboard': (context) => UserDashboard(), // Define the route for User Dashboard
        '/admin_login': (context) => AdminLoginScreen(), // Define the route for Admin Login
        '/admin_dashboard': (context) => AdminDashboard(), // Define the route for Admin Dashboard
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('404 - Not Found'),
            ),
            body: Center(
              child: Text('404 - Page not found'),
            ),
          ),
        );
      },
    );
  }
}
