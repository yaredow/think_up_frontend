import 'package:flutter/material.dart';

class AlarmSettingsFormWidget extends StatefulWidget {
  const AlarmSettingsFormWidget({super.key});

  @override
  State<AlarmSettingsFormWidget> createState() =>
      _AlarmSettingsFormWidgetState();
}

class _AlarmSettingsFormWidgetState extends State<AlarmSettingsFormWidget> {
  bool _isRepeating = true;
  final String _alarmSound = "Default";

  final TextEditingController _nameController = TextEditingController();

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
            padding: EdgeInsetsGeometry.symmetric(vertical: 16),
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
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSettingRow(
          title: "Alarm Name",
          trailing: Expanded(
            child: TextField(
              controller: _nameController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: "Wake Up",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          onTap: () {},
          showDivider: false,
        ),
        _buildSettingRow(
          title: 'Alarm sound',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _alarmSound,
                style: TextStyle(color: Colors.green.shade600, fontSize: 16),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.green.shade600,
              ),
            ],
          ),
          onTap: () {},
          showDivider: false,
        ),
        _buildSettingRow(
          title: 'Repeat',
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: _isRepeating,
              activeThumbColor: Colors.green.shade600,
              onChanged: (value) {
                setState(() {
                  _isRepeating = value;
                });
              },
            ),
          ),
          showDivider: false,
        ),
      ],
    );
  }
}
