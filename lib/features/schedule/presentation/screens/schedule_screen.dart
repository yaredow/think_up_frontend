import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/core/permissions/permission_service.dart';
import 'package:think_up/features/schedule/domain/entities/alarm.dart';
import 'package:think_up/features/schedule/presentation/provider/alarm_provider.dart';
import 'package:think_up/features/schedule/presentation/widgets/alarm_form_sheet_widget.dart';
import 'package:think_up/features/schedule/presentation/widgets/alarm_title_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
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

  Future<void> onFabPressed() async {
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

    if (!mounted) return;

    final TimeOfDay? selectedTime = await showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const AlarmFormSheetWidget();
      },
    );

    if (!mounted) return;

    if (selectedTime != null) {
      final alarmProvider = context.read<AlarmProvider>();

      final newAlarm = _createNewAlarm(alarmProvider, selectedTime);
      alarmProvider.addAlarm(newAlarm);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alarm "${newAlarm.title}" scheduled')),
        );
      }
    }
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
            return const Center(child: Text("No Alarm Set"));
          }

          return ListView.builder(
            itemCount: provider.alarms.length,
            itemBuilder: (context, index) {
              final alarm = provider.alarms[index];
              return AlarmTile(alarm: alarm);
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
