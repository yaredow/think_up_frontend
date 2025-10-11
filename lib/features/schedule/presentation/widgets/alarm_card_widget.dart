import 'package:flutter/material.dart';
import 'package:think_up/features/schedule/domain/entities/alarm.dart';

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

  @override
  Widget build(BuildContext context) {
    final TimeOfDay alarmTime = TimeOfDay.fromDateTime(alarm.time);

    final String recurrence = "Everyday";
    final Color accentColor = Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: accentColor.withValues(alpha: 0.5),
            width: 2.0,
          ),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: accentColor),
                      const SizedBox(width: 8),
                      Text(
                        recurrence,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: true,
                    onChanged: onToggle,
                    activeThumbColor: Colors.white,
                    activeTrackColor: accentColor,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                alarmTime.format(context),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    alarm.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                    onPressed: onDelete,
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
