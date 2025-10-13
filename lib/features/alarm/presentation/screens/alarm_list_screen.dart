import 'package:flutter/material.dart';

class AlarmListScreen extends StatelessWidget {
  const AlarmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarm"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/create-alarm");
            },
            icon: Icon(Icons.add, size: 26),
          ),
        ],
      ),
      body: Center(child: Text("Alarm List")),
    );
  }
}
