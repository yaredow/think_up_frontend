import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/app/router.dart';
import 'package:think_up/core/permissions/permission_service.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';
import 'package:think_up/features/alarm/presentation/widgets/alarm_card_widget.dart';
import 'package:think_up/features/alarm/presentation/widgets/alarm_form_sheet_widget.dart';

class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<AlarmListScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(
      () => Provider.of<AlarmProvider>(context, listen: false).loadAlarms(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _checkPermissionSAfterResume();
    }
  }

  Future<void> _checkPermissionSAfterResume() async {
    final permissionService = context.read<PermissionService>();
    final notif = await permissionService.isNotificationGranted();
    final exact = await permissionService.canScheduleExactAlarm();
    if (!mounted) return;
    final msg = notif ? "Notification: granted" : "Notification: denied";
    final exactMsg = exact ? 'Exact alarms: allowed' : 'Exact alarms: denied';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$msg · $exactMsg'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> onAddAlarmPressed() async {
    final permissionService = context.read<PermissionService>();

    final notifGranted =
        await permissionService.isNotificationGranted() ||
        await permissionService.requestNotificationPermission();

    if (!notifGranted) {
      final open = await _showOpenSettingsDialog();
      if (open == true) {
        try {
          await permissionService.openAppSettings();
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open settings')),
            );
          }
        }
      }
      return;
    }

    final canExact = await permissionService.canScheduleExactAlarm();
    if (!canExact) {
      final requested = await permissionService.requestScheduleExactAlarm();
      if (!requested && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exact alarm permission not granted')),
        );
        return;
      }
      // If request opens settings, user must come back to app; we re-check on resume.
    }
  
  AppRouter.
  }

  Future<bool?> _showOpenSettingsDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Notification required"),
        content: const Text(
          "Enable notifications to receive alarms. Open app settings?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Open settings"),
          ),
        ],
      ),
    );
  }

  Alarm _createNewAlarm(AlarmProvider alarmProvider, TimeOfDay selectedTime) {
    final nextId = alarmProvider.alarms.isEmpty
        ? 1
        : alarmProvider.alarms.last.id + 1;

    final now = DateTime.now();

    DateTime scheduleTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduleTime.isBefore(now)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    return Alarm(id: nextId, title: "Alarm $nextId", time: scheduleTime);
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Alarm?"),
        content: const Text(
          "Are you sure you want to permanently delete this alarm?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> onAlarmDelete(String alarmId) async {
    final confirmed = await _showDeleteConfirmationDialog();

    if (!mounted || !confirmed) return;

    final alarmProvider = context.read<AlarmProvider>();

    alarmProvider.deleteAlarm(alarmId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Alarm Deleted"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarms"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<AlarmProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.alarms.isEmpty) {
            return const Center(child: Text("No Alarm Set"));
          }

          return ListView.builder(
            itemCount: provider.alarms.length,
            itemBuilder: (context, index) {
              final alarm = provider.alarms[index];
              return AlarmCardWidget(
                alarm: alarm,
                onDelete: () => onAlarmDelete(alarm.id.toString()),
                onToggle: (value) {
                  print("Toggle alarm");
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onFabPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
