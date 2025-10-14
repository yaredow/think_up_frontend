import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';
import 'package:think_up/features/alarm/presentation/widgets/ringtone_selection_widget.dart';
import 'alarm_name_field_widget.dart';

class AlarmSettingsFormWidget extends StatelessWidget {
  const AlarmSettingsFormWidget({super.key});

  Widget _buildSettingRow({
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Colors.black12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: AlarmNameFieldWidget(),
        ),
        const Divider(height: 1, color: Colors.black12),

        Consumer<AlarmProvider>(
          builder: (context, provider, child) {
            final draftAlarm = provider.draftAlarm;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildSettingRow(
                    title: 'Alarm sound',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          draftAlarm.sound,
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.green.shade600,
                        ),
                      ],
                    ),
                    onTap: () async {
                      final selectedId = await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return RingtoneSelectionWidget(
                            selectedRingtoneId: "",
                            onRingtoneSelected: (value) {},
                          );
                        },
                      );
                    },
                    showDivider: true,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildSettingRow(
                    title: 'Repeat',
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                        value: draftAlarm.isRepeating,
                        activeThumbColor: Colors.green.shade600,
                        activeTrackColor: Colors.green.shade600,
                        onChanged: (value) {
                          alarmProvider.updateRepeat(value);
                        },
                      ),
                    ),
                    onTap: () {
                      alarmProvider.updateRepeat(!draftAlarm.isRepeating);
                    },
                    showDivider: false,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
