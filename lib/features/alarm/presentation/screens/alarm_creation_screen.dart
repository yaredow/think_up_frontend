import 'package:flutter/material.dart';
import 'package:think_up/features/alarm/presentation/widgets/circular_time_picker.dart';

class AlarmCreationScreen extends StatelessWidget {
  const AlarmCreationScreen({super.key, this.alarmId});

  final String? alarmId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Alarm",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(children: [CircularTimePicker()]),
      ),
    );
  }
}
