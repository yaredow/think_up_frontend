import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';

class AlarmNameFieldWidget extends StatelessWidget {
  const AlarmNameFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AlarmProvider>(context, listen: false);

    final initalName = provider.draftAlarm.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Alarm Name",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextFormField(
          initialValue: initalName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            hintText: "Wake Up",
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 4),
            isDense: true,
          ),
          onChanged: (value) {
            provider.updateName(value);
          },
        ),
      ],
    );
  }
}
