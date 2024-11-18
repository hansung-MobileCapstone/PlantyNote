// notification_switch.dart         # 알림 토글 UI
import 'package:flutter/material.dart';

class NotificationSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const NotificationSwitch({
    super.key,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('알림'),
        const Spacer(),
        Switch(
          value: isActive,
          onChanged: onToggle,
        ),
      ],
    );
  }
}
