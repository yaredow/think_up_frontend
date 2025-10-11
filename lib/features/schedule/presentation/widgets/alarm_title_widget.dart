import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/schedule/domain/entities/alarm.dart';
import 'package:think_up/features/schedule/presentation/provider/alarm_provider.dart';

class AlarmTile extends StatelessWidget {
  final Alarm alarm;

  const AlarmTile({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(alarm.title),
      subtitle: Text(alarm.time.toString()),
      trailing: IconButton(
        onPressed: () {
          Provider.of<AlarmProvider>(
            context,
            listen: false,
          ).deleteAlarm(alarm.id.toString());
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}
