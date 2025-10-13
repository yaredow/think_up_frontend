import 'package:flutter/material.dart';

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

  final Set<String> _selectedDays = {"Thu", "Fri"};

  void _toggleDays(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Settings",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _daysOfWeek.map((day) {
            final isSelected = _selectedDays.contains(day);
            final activeColor = Colors.green.shade600;

            return GestureDetector(
              onTap: () => _toggleDays(day),
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
  }
}
