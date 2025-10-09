import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/schedule/domain/entities/alarm.dart';
import 'package:think_up/features/schedule/presentation/provider/alarm_provider.dart';
import 'package:think_up/features/schedule/presentation/widgets/alarm_title.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AlarmProvider>(context, listen: false).loadAlarms(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alarms")),
      body: Consumer<AlarmProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.alarms.isEmpty) {
            return const Center(child: Text("No alarms set"));
          }

          return ListView.builder(
            itemCount: provider.alarms.length,
            itemBuilder: (context, index) {
              final alarm = provider.alarms[index];
              return AlarmTitle(alarm: alarm);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final alarmProvider = Provider.of<AlarmProvider>(
            context,
            listen: false,
          );

          final newAlarm = alarmProvider.alarms.isEmpty
              ? Alarm(
                  id: 1,
                  title: "Alarm 1",
                  time: DateTime.now(),
                  isActive: false,
                )
              : Alarm(
                  id: alarmProvider.alarms.last.id + 1,
                  title: "Alarm ${alarmProvider.alarms.last.id + 1}",
                  time: DateTime.now(),
                  isActive: false,
                );
          alarmProvider.addAlarm(newAlarm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
