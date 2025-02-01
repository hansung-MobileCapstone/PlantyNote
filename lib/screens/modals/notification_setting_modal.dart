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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '알림 시간 설정',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${selectedTime.format(context)}',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 16),
            Row (
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 12, minute: 00),
                      initialEntryMode: TimePickerEntryMode.input,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData(
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFF4B7E5B), // 버튼 텍스트 색상
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            textSelectionTheme: const TextSelectionThemeData(
                              cursorColor: Color(0xFFE6E6E6), // 커서 색상
                              selectionColor: Color(0xFF6ABF69),
                              selectionHandleColor: Color(0xFFE6E6E6),
                            ),
                            timePickerTheme: TimePickerThemeData(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Color(0xFFFFFFFF),
                              hourMinuteColor: MaterialStateColor.resolveWith(
                                    (states) => states.contains(MaterialState.selected)
                                    ? Color(0xFF4B7E5B)
                                    : Color(0xFFE6E6E6),
                              ),
                              hourMinuteTextColor: MaterialStateColor.resolveWith(
                                    (states) => states.contains(MaterialState.selected)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              dialBackgroundColor: Color(0xFF4B7E5B), // AM/PM
                              dayPeriodColor: MaterialStateColor.resolveWith(
                                    (states) => states.contains(MaterialState.selected)
                                    ? Color(0xFF4B7E5B)
                                    : Color(0xFFE6E6E6),
                              ),
                              dayPeriodTextColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                states.contains(MaterialState.selected)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              entryModeIconColor: Color(0xFF4B7E5B),
                              helpTextStyle: const TextStyle(
                                color: Color(0xFF4B7E5B),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE6E6E6),
                  ),
                  child: const Text('시간 변경', style: TextStyle(fontSize: 15, color: Colors.black),),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4B7E5B),
                  ),
                  child: const Text('완료', style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
