import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarModal extends StatelessWidget {
  const CalendarModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: (selectedDate) {
              Navigator.pop(context, selectedDate);
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('선택'),
          ),
        ],
      ),
    );
  }
}
