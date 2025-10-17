import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';
import 'package:think_up/features/alarm/presentation/widgets/ring_actions.dart';
import 'package:think_up/features/alarm/presentation/widgets/ring_background.dart';
import 'package:think_up/features/alarm/presentation/widgets/ring_header.dart';
import 'package:think_up/features/alarm/presentation/widgets/ring_visual.dart';

class AlarmRingScreen extends StatefulWidget {
  final String alarmId;

  const AlarmRingScreen({super.key, required this.alarmId});

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPlayback());
  }

  Future<void> _startPlayback() async {
    final provider = context.read<AlarmProvider>();
    final alarmId = int.tryParse(widget.alarmId);
    final alarm = alarmId != null ? provider.findAlarm(alarmId) : null;
    final asset = provider.resolveRingtoneAsset(
      alarm?.sound ?? provider.draftAlarm.sound,
    );

    await _player.setLoopMode(LoopMode.one);
    await _player.setAsset(asset);
    await _player.play();
  }

  void _stopAlarm() async {
    await _player.stop();
    if (mounted) Navigator.of(context).pop();
  }

  void _snoozeAlarm() async {
    await _player.stop();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    final alarmId = int.tryParse(widget.alarmId);
    final alarm = alarmId != null ? alarmProvider.findAlarm(alarmId) : null;

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
