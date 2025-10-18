import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';
import 'package:think_up/features/puzzle/presentation/math_puzzle_screen.dart';
import 'package:think_up/features/puzzle/presentation/sequence_puzzle_screen.dart';
import 'package:think_up/features/puzzle/presentation/tile_puzzle_screen.dart';

class AlarmPuzzleDispatcherScreen extends StatefulWidget {
  final int alarmId;
  const AlarmPuzzleDispatcherScreen({super.key, required this.alarmId});

  @override
  State<AlarmPuzzleDispatcherScreen> createState() =>
      _AlarmPuzzleDispatcherScreenState();
}

class _AlarmPuzzleDispatcherScreenState
    extends State<AlarmPuzzleDispatcherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _dispatchPuzzle());
  }

  Future<void> _dispatchPuzzle() async {
    final alarmProvider = context.read<AlarmProvider>();
    final alarm = await alarmProvider.getAlarmById(widget.alarmId);

    if (alarm == null) {
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    Widget target;
    switch (alarm.puzzleCategory) {
      case PuzzleCategory.math:
        target = MathPuzzleScreen(
          alarmId: widget.alarmId,
          difficulty: alarm.puzzleDifficulty,
        );
        break;
      case PuzzleCategory.sequence:
        target = const SequencePuzzleScreen();
        break;
      case PuzzleCategory.tile:
        target = const TilePuzzleScreen();
        break;
    }

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
