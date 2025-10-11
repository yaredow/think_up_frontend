import 'package:flutter/material.dart';

class AlarmCreationScreen extends StatelessWidget {
  const AlarmCreationScreen({super.key, this.alarmId});

  final String? alarmId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Create alarm")),
    );
  }
}
