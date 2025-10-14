import 'package:flutter/material.dart';
import 'package:think_up/features/alarm/presentation/widgets/alarm_settings_form_widget.dart';
import 'package:think_up/features/alarm/presentation/widgets/circular_time_picker.dart';
import 'package:think_up/features/alarm/presentation/widgets/day_selector_widget.dart';
import 'package:think_up/features/alarm/presentation/widgets/new_alarm_save_button.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 16),
              CircularTimePicker(),
              const SizedBox(height: 10),
              const DaySelectorWidget(),
              const SizedBox(height: 10),
              const AlarmSettingsFormWidget(),
              const SizedBox(height: 26),
              NewAlarmSaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
