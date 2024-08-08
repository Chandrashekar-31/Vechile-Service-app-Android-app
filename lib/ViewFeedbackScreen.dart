import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewFeedbackScreen extends StatefulWidget {
  @override
  _ViewFeedbackScreenState createState() => _ViewFeedbackScreenState();
}

class _ViewFeedbackScreenState extends State<ViewFeedbackScreen> {
  late Future<List<Feedback>> _feedbacks;

  @override
  void initState() {
    super.initState();
    _feedbacks = fetchFeedback();
  }

  Future<List<Feedback>> fetchFeedback() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.153.127/service/fetch_feedback.php'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Feedback.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load feedback');
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Feedback'),
        backgroundColor: Colors.deepPurple, // AppBar background color
      ),
      body: Container(
        color: Colors.grey[200], // Background color for the whole screen
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Feedback>>(
          future: _feedbacks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No feedback available', style: TextStyle(color: Colors.black54)));
            } else {
              return ListView(
                padding: EdgeInsets.zero, // Remove default padding for the ListView
                children: snapshot.data!.map((feedback) => Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Colors.white, // Background color for the Card
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    tileColor: Colors.white, // Background color for the ListTile
                    leading: Icon(Icons.feedback, color: Colors.deepPurple), // Icon for the ListTile
                    title: Text(
                      'User ID: ${feedback.userId}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple, // Color for the title text
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text('Feedback: ${feedback.feedback}', style: TextStyle(color: Colors.black87)),
                        SizedBox(height: 4),
                        Text('Suggestions: ${feedback.suggestions}', style: TextStyle(color: Colors.black87)),
                        SizedBox(height: 4),
                        Text('Rating: ${feedback.rating.toStringAsFixed(1)}', style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ),
                )).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}

class Feedback {
  final int userId;
  final String feedback;
  final String suggestions;
  final double rating;

  Feedback({
    required this.userId,
    required this.feedback,
    required this.suggestions,
    required this.rating,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      userId: int.tryParse(json['user_id'].toString()) ?? 0, // Handle user_id as String
      feedback: json['feedback'],
      suggestions: json['suggestions'],
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
    );
  }
}
