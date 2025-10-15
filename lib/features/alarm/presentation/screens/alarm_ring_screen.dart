import 'package:flutter/material.dart';

class AlarmRingScreen extends StatefulWidget {
  final String alarmId;

  const AlarmRingScreen({super.key, required this.alarmId});

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _stopAlarm() {
    // Logic to stop the alarm
    Navigator.of(context).pop();
  }

  void _snoozeAlarm() {
    // Logic to snooze the alarm
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Wake up",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text(
              'Alarm ID: ${widget.alarmId}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _snoozeAlarm,
              child: const Text(
                'SNOOZE (9 min)',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
