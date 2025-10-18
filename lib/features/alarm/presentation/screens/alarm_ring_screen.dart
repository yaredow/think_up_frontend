import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/core/alarm_audio_controller.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';
import 'package:think_up/features/alarm/presentation/widgets/ring_actions.dart';
import 'package:think_up/features/alarm/presentation/widgets/ring_background.dart';
import 'package:think_up/features/alarm/presentation/widgets/ring_header.dart';
import 'package:think_up/features/alarm/presentation/widgets/ring_visual.dart';

class AlarmRingScreen extends StatefulWidget {
  final int alarmId;

  const AlarmRingScreen({super.key, required this.alarmId});

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  void _stopAlarm() async {
    await AlarmAudioController.instance.stop();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _snoozeAlarm() async {
    final alarmId = widget.alarmId;
    final provider = context.read<AlarmProvider>();
    await provider.snoozeAlarm(alarmId, const Duration(minutes: 5));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    AlarmAudioController.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    final alarmId = widget.alarmId;
    final alarm = alarmProvider.findAlarm(alarmId);

    return Scaffold(
      body: RingBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RingHeader(
                alarmLabel: alarm?.title,
                nextOccurrence: alarmProvider.nextOccurrenceForDraft(),
              ),
              Expanded(
                child: Center(child: RingVisual(title: alarm?.title ?? '')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: RingActions(
                  onDismiss: _stopAlarm,
                  onSnooze: _snoozeAlarm,
                  snoozeDuration: const Duration(minutes: 5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
