import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';

class DaySelectorWidget extends StatefulWidget {
  const DaySelectorWidget({super.key});

  @override
  State<DaySelectorWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<DaySelectorWidget> {
  final List<String> _daysOfWeek = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  void _toggleDays(BuildContext context, day) {
    final provider = Provider.of<AlarmProvider>(context, listen: false);
    final List<String> updatedDays = List.from(provider.draftAlarm.days);

    if (updatedDays.contains(day)) {
      updatedDays.remove(day);
    } else {
      updatedDays.add(day);
    }

    provider.updateDays(updatedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmProvider>(
      builder: (context, provider, child) {
        final currentDays = provider.draftAlarm.days;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 11),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _daysOfWeek.map((day) {
                final isSelected = currentDays.contains(day);
                final activeColor = Colors.green.shade600;

                return GestureDetector(
                  onTap: () => _toggleDays(context, day),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? activeColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
