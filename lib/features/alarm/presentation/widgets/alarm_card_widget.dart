import 'package:flutter/material.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';

class AlarmCardWidget extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const AlarmCardWidget({
    super.key,
    required this.alarm,
    required this.onDelete,
    required this.onToggle,
  });

  String _formatRecurrence(Alarm alarm) {
    if (!alarm.isRepeating) {
      return 'One-time';
    }
    if (alarm.days.length == 7) {
      return 'Everyday';
    }
    if (alarm.days.isEmpty) {
      return 'One-time';
    }
    return alarm.days.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final TimeOfDay alarmTime = TimeOfDay.fromDateTime(alarm.time);

    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );

    final formattedTime = localizations.formatTimeOfDay(
      alarmTime,
      alwaysUse24HourFormat: false,
    );

    final String recurrence = _formatRecurrence(alarm);
    final Color accentColor = Colors.green;
    final isEnabled = alarm.isActive;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(width: 1.5, color: accentColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: accentColor),
                      const SizedBox(width: 8.0),
                      Text(
                        alarm.title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isEnabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: accentColor,
                    onChanged: onToggle,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    recurrence,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
