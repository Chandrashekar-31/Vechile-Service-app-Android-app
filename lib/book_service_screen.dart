import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'choose_payment_method_screen.dart'; // Import the ChoosePaymentMethodScreen

class BookServiceScreen extends StatefulWidget {
  final int userId;
  final List services;

  BookServiceScreen({required this.userId, required this.services});

  @override
  _BookServiceScreenState createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _vehicle;
  String? _service;
  String? _model;
  DateTime? _appointmentDate;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _bookService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await http.post(
        Uri.parse('http://192.168.153.127/service/book_service.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'user_id': widget.userId.toString(),
          'vehicle': _vehicle!,
          'service': _service!,
          'model': _model!,
          'appointment_date': _appointmentDate != null ? _formatDate(_appointmentDate!) : '',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successful')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChoosePaymentMethodScreen()), // Navigate to ChoosePaymentMethodScreen
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${response.body}')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_addLeadingZero(date.month)}-${_addLeadingZero(date.day)}';
  }

  String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Service'),
        backgroundColor: Colors.blue[400], // Darker blue
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white], // Light blue gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                icon: Icons.directions_car,
                label: 'Vehicle',
                onSaved: (value) => _vehicle = value,
                validator: (value) => value!.isEmpty ? 'Please enter vehicle' : null,
              ),
              _buildTextField(
                icon: Icons.build,
                label: 'Service',
                onSaved: (value) => _service = value,
                validator: (value) => value!.isEmpty ? 'Please enter service' : null,
              ),
              _buildTextField(
                icon: Icons.model_training,
                label: 'Model',
                onSaved: (value) => _model = value,
                validator: (value) => value!.isEmpty ? 'Please enter model' : null,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _appointmentDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue[400]),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _appointmentDate == null
                              ? 'Select Appointment Date'
                              : 'Appointment Date: ${_formatDate(_appointmentDate!)}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton(
                  onPressed: () {
                    _controller.forward().then((_) {
                      _bookService();
                      _controller.reverse();
                    });
                  },
                  child: Text('Book Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5, // Button shadow
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue[400]),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
