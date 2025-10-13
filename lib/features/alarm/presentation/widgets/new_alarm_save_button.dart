import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';

class NewAlarmSaveButton extends StatelessWidget {
  const NewAlarmSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    final isReadyToSave = alarmProvider.draftAlarm.days.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isReadyToSave
            ? () {
                _handleSave(context);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          "Save",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void _handleSave(BuildContext context) async {
  final provider = Provider.of<AlarmProvider>(context, listen: false);

  try {
    await provider.saveAlarm();

    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Alarm successfully saved")));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save alarm $e")));
    }
  }
}
