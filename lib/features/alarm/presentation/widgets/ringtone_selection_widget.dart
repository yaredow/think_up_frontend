import 'package:flutter/material.dart';
import '../models/ringtone_options.dart';

class RingtoneSelectionWidget extends StatelessWidget {
  final String? selectedRingtoneId;
  final ValueChanged<String> onRingtoneSelected;

  const RingtoneSelectionWidget({
    super.key,
    this.selectedRingtoneId,
    required this.onRingtoneSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Select Sound",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: kAvailableRingtones.length,
            itemBuilder: (context, index) {
              final ringtone = kAvailableRingtones[index];
              final isSelected = ringtone.id == selectedRingtoneId;

              return ListTile(
                title: Text(ringtone.name),
                trailing: isSelected ? const Icon(Icons.check) : null,
                selected: isSelected,
                onTap: () => onRingtoneSelected(ringtone.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
