import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RingHeader extends StatefulWidget {
  final String? alarmLabel;
  final DateTime? nextOccurrence;

  const RingHeader({super.key, this.alarmLabel, this.nextOccurrence});

  @override
  State<RingHeader> createState() => _RingHeaderState();
}

class _RingHeaderState extends State<RingHeader> {
  late DateTime _now;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration diff) {
    if (diff.isNegative) return 'Now';
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours == 0) {
      return minutes == 1 ? 'in 1 minute' : 'in $minutes minutes';
    }
    if (minutes == 0) {
      return hours == 1 ? 'in 1 hour' : 'in $hours hours';
    }
    final hoursPart = hours == 1 ? '1 hour' : '$hours hours';
    final minutesPart = minutes == 1 ? '1 minute' : '$minutes minutes';
    return 'in $hoursPart $minutesPart';
  }

  @override
  Widget build(BuildContext context) {
    final timeStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    final dateStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Colors.white70,
      letterSpacing: 1.2,
    );

    final nextStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: Colors.white70);

    final timeText = DateFormat.jm().format(_now);
    final dateText = DateFormat('EEE, MMM d').format(_now);

    final nextText = widget.nextOccurrence == null
        ? null
        : 'Next at ${DateFormat.jm().format(widget.nextOccurrence!)} • '
              '${_formatDuration(widget.nextOccurrence!.difference(_now))}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timeText, style: timeStyle),
          const SizedBox(height: 4),
          Text(dateText.toUpperCase(), style: dateStyle),
          if (nextText != null) ...[
            const SizedBox(height: 16),
            Text(nextText, style: nextStyle),
          ],
        ],
      ),
    );
  }
}
