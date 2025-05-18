import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarModal extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CalendarModal({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // 캘린더 위젯
            SizedBox(
              height: 300,
              child: Theme(
                data: Theme.of(context).copyWith(
                  // 캘린더 스타일 커스터마이징
                  colorScheme: ColorScheme.light(
                    primary: const Color(0xFF4B7E5B), // 선택된 날짜 배경색
                    onPrimary: Colors.white, // 선택된 날짜 텍스트 색상
                    onSurface: const Color(0xFF697386), // 일반 날짜 텍스트 색상
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4B7E5B), // 화살표 색상
                    ),
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: widget.initialDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            // 선택 버튼
            TextButton(
              onPressed: () {
                widget.onDateSelected(selectedDate); // 선택된 날짜 전달
                context.pop(); // 모달 닫기
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF4B7E5B), // 버튼 배경색
                foregroundColor: Colors.white, // 버튼 텍스트 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
              ),
              child: const Text(
                '선택',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
