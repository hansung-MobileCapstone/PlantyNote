import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationSettingModal extends StatefulWidget {
  const NotificationSettingModal({super.key});

  @override
  State<NotificationSettingModal> createState() =>
      _NotificationSettingModalState();
}

class _NotificationSettingModalState extends State<NotificationSettingModal> {
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '알림 시간 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              child: const Text('시간 선택'),
            ),
            const SizedBox(height: 16),
            Text(
              '선택된 시간: ${selectedTime.format(context)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
