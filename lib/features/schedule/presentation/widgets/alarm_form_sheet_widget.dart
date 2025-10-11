import 'package:flutter/material.dart';

class AlarmFormSheetWidget extends StatefulWidget {
  const AlarmFormSheetWidget({super.key});

  @override
  State<AlarmFormSheetWidget> createState() => _AlarmFormSheetWidgetState();
}

class _AlarmFormSheetWidgetState extends State<AlarmFormSheetWidget> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          "Set New Alarm",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _pickTime,
          child: Text(
            _selectedTime.format(context),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedTime);
              },
              child: Text("Schedule"),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
