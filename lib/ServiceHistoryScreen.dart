import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceHistoryScreen extends StatefulWidget {
  final int userId;

  ServiceHistoryScreen({required this.userId});

  @override
  _ServiceHistoryScreenState createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  List bookings = [];

  Future<void> fetchBookings() async {
    final response = await http.post(
      Uri.parse('http://192.168.153.127/service/fetch_service_history.php'),
      body: {'user_id': widget.userId.toString()},
    );

    if (response.statusCode == 200) {
      setState(() {
        bookings = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final response = await http.post(
      Uri.parse('http://192.168.153.127/service/cancel_appointment.php'),
      body: {'appointment_id': appointmentId.toString()},
    );

    if (response.statusCode == 200) {
      setState(() {
        bookings.removeWhere((booking) => booking['id'] == appointmentId);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment canceled')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to cancel appointment')));
    }
  }

  Future<void> rescheduleAppointment(int appointmentId, String newDate) async {
    final response = await http.post(
      Uri.parse('http://192.168.153.127/service/reschedule_appointment.php'),
      body: {
        'appointment_id': appointmentId.toString(),
        'new_appointment_date': newDate,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        final index = bookings.indexWhere((booking) => booking['id'] == appointmentId);
        if (index != -1) {
          bookings[index]['appointment_date'] = newDate;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment rescheduled')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to reschedule appointment')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service History'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.deepPurple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: bookings.isEmpty
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
          ),
        )
            : ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Card(
                key: ValueKey(booking['id']),
                margin: EdgeInsets.all(8.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    'Service: ${booking['service']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${booking['appointment_date']} - Status: ${booking['status']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => cancelAppointment(booking['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              rescheduleAppointment(booking['id'], selectedDate.toIso8601String());
                            }
                          });
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
    );
  }
}
