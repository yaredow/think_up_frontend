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

  @override
  Widget build(BuildContext context) {
    final TimeOfDay alarmTime = TimeOfDay.fromDateTime(alarm.time);

    final String recurrence = "Everyday";
    final Color accentColor = Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(width: 1.5, color: accentColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                      SizedBox(width: 8.0),
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
                    activeThumbColor: Colors.white,
                    activeTrackColor: accentColor,
                    onChanged: onToggle,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                alarmTime.format(context),
                style: TextStyle(
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
                    style: TextStyle(color: Colors.black87, fontSize: 16),
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
