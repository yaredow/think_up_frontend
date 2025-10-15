import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/ringtone_options.dart';

class RingtoneSelectionWidget extends StatefulWidget {
  final String? selectedRingtoneId;
  final ValueChanged<String> onSelectionConfirmed;

  const RingtoneSelectionWidget({
    super.key,
    this.selectedRingtoneId,
    required this.onSelectionConfirmed,
  });

  @override
  State<RingtoneSelectionWidget> createState() =>
      _RingtoneSelectionWidgetState();
}

class _RingtoneSelectionWidgetState extends State<RingtoneSelectionWidget> {
  late final AudioPlayer _player;
  late String _currentlySelected;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    unawaited(_player.setLoopMode(LoopMode.one));
    _currentlySelected =
        widget.selectedRingtoneId ?? kAvailableRingtones.first.id;
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  Future<void> _preview(RingtoneOption ringtone) async {
    try {
      await _player.stop();
      await _player.setAsset(ringtone.assetPath);
      await _player.play();
    } catch (error) {
      debugPrint('Error playing ringtone: $error');
    }
  }

  TextStyle _titleStyle(bool isSelected, BuildContext context) {
    final base = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    return base.copyWith(
      fontSize: 16,
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      color: isSelected ? Theme.of(context).colorScheme.primary : base.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return SizedBox(
      height: maxHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Sound',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    widget.onSelectionConfirmed(_currentlySelected);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: RadioGroup<String>(
              onChanged: (value) {
                if (value == null) return;
                final ringtone = kAvailableRingtones.firstWhere(
                  (option) => option.id == value,
                  orElse: () => kAvailableRingtones.first,
                );

                setState(() => _currentlySelected = value);
                unawaited(_preview(ringtone));
              },
              child: ListView.builder(
                itemCount: kAvailableRingtones.length,
                itemBuilder: (context, index) {
                  final ringtone = kAvailableRingtones[index];
                  final isSelected = ringtone.id == _currentlySelected;

                  return RadioListTile<String>(
                    value: ringtone.id,
                    controlAffinity: ListTileControlAffinity.leading,
                    selected: isSelected,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      ringtone.name,
                      style: _titleStyle(isSelected, context),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
