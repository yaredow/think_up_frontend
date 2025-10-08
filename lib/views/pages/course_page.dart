import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:think_up_frontend/views/data/classes/activit_class.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<Activity> futureActivity;

  @override
  void initState() {
    futureActivity = fetchActivity();

    super.initState();
  }

  Future<Activity> fetchActivity() async {
    final response = await http.get(
      Uri.parse("https://bored-api.appbrewery.com/random"),
    );

    if (response.statusCode == 200) {
      return Activity.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception("Failed to load album");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Activity>(
        future: futureActivity,
        builder: (context, AsyncSnapshot<Activity> snapshot) {
          Widget widget;

          if (snapshot.connectionState == ConnectionState.waiting) {
            widget = Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            widget = Center(
              child: Text(
                snapshot.data!.activity,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasError) {
            widget = Center(child: Text("${snapshot.error}"));
          } else {
            widget = Center(child: Text("No data"));
          }

          return widget;
        },
      ),
    );
  }
}
