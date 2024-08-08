import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ServiceHistoryScreen.dart';
import 'edit_profile_screen.dart';
import 'login.dart';
import 'search_bar.dart' as custom;
import 'book_service_screen.dart';
import 'feedback_form.dart';
import 'contact_screen.dart'; // Import the ContactScreen
import 'settings_screen.dart'; // Import the SettingsScreen

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> services = [];
  bool isLoading = false;
  bool isServicesVisible = false;
  Map<String, dynamic> user = {
    'id': 1,
    'name': 'User Name',
    'email': 'user@example.com',
    'phone': '1234567890',
  };

  Future<void> fetchServices() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('http://192.168.153.127/service/services.php'));

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> jsonResponse = json.decode(response.body);
        services = jsonResponse.map((service) => Map<String, dynamic>.from(service)).toList();
        isLoading = false;
        isServicesVisible = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load services');
    }
  }

  void toggleServicesVisibility() {
    if (isServicesVisible) {
      setState(() {
        isServicesVisible = false;
      });
    } else {
      fetchServices();
    }
  }

  Future<void> navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
    );

    if (result != null) {
      setState(() {
        user = result;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ); // Navigate to login screen
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToBookService() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookServiceScreen(userId: user['id'], services: services)),
    );
  }

  void _navigateToServiceHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceHistoryScreen(userId: user['id'])),
    );
  }

  void _navigateToFeedbackForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackForm(userId: user['id'])),
    );
  }

  void _navigateToContactScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactScreen()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title, VoidCallback onPressed, IconData icon, Color color) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 8,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 3)],
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user['name']),
              accountEmail: Text(user['email']),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  user['name'][0].toUpperCase(),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                navigateToEditProfile();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _navigateToSettings();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                custom.SearchBar(),
                SizedBox(height: 20),
                _buildDashboardButton(
                  context,
                  isServicesVisible ? 'Hide Services' : 'New Service Available',
                  toggleServicesVisibility,
                  Icons.list,
                  Colors.teal,
                ),
                SizedBox(height: 20),
                _buildDashboardButton(
                  context,
                  'Book a Service',
                  _navigateToBookService,
                  Icons.book,
                  Colors.deepPurple,
                ),
                SizedBox(height: 20),
                _buildDashboardButton(
                  context,
                  'View Service History',
                  _navigateToServiceHistory,
                  Icons.history,
                  Colors.orange,
                ),
                SizedBox(height: 20),
                _buildDashboardButton(
                  context,
                  'Submit Feedback',
                  _navigateToFeedbackForm,
                  Icons.feedback,
                  Colors.blue,
                ),
                SizedBox(height: 20),
                _buildDashboardButton(
                  context,
                  'Contact Us',
                  _navigateToContactScreen,
                  Icons.contact_mail,
                  Colors.green,
                ),
                SizedBox(height: 20),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (isServicesVisible)
                  SizedBox(
                    height: 300, // Limit the height for ListView
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(service['service_name']),
                              subtitle: Text(service['description']),
                              trailing: Text("\$${service['price'].toString()}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToBookService,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
