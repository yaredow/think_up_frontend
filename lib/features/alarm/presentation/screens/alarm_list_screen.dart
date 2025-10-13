import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';
import 'package:think_up/features/alarm/presentation/widgets/alarm_card_widget.dart';

class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlarmProvider>(context, listen: false).loadAlarms();
    });
  }

  void handleOnDeleteAlarm(
    BuildContext context,
    String id,
    String title,
  ) async {
    final provider = Provider.of<AlarmProvider>(context, listen: false);

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Alarm"),
          content: Text('Are you sure you want to delete the alarm: "$title"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // User cancels
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // User confirms
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      try {
        await provider.deleteAlarmUseCase(id);

        if (!context.mounted) return;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Alarm deleted successfully")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to delete alarm: $e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Alarm"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/create-alarm");
            },
            icon: Icon(Icons.add, size: 26),
          ),
        ],
      ),
      body: Consumer<AlarmProvider>(
        builder: (context, provider, child) {
          final alarms = provider.savedAlarms;
          Widget content;

          if (alarms.isEmpty) {
            content = const Center(
              child: Text(
                "No alarms set.\nTap '+' to create one.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            content = ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];

                return AlarmCardWidget(
                  alarm: alarm,
                  onDelete: () =>
                      handleOnDeleteAlarm(context, alarm.id, alarm.title),
                  // TODO: Implement actual toggle logic in the Provider
                  onToggle: (isActive) {
                    // Example: provider.toggleAlarm(alarm.id, isActive);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${alarm.title} toggled $isActive'),
                      ),
                    );
                  },
                );
              },
            );
          }
          return content;
        },
      ),
    );
  }
}
