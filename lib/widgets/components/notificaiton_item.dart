import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationItem extends StatefulWidget {
  final String title; // 제목
  final String date; // 날짜
  final String message; // 알림메세지
  final bool isRead; // 읽음 여부
  final ValueChanged<bool> onReadStatusChanged;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.date,
    required this.message,
    required this.isRead,
    required this.onReadStatusChanged,
  }) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    _isRead = widget.isRead; // 초기값 설정
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: GestureDetector(
        onTap: () {
          if (!_isRead) {
            setState(() {
              _isRead = true; // 클릭하면 읽음 상태로 변경
            });
            widget.onReadStatusChanged(true); // 상태 변화 전달
            context.go('/plants'); // 내식물모음페이지로 이동 (물주기 유도)
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: _isRead ? Colors.white : const Color(0x99ECF7F2),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 물방울 아이콘
              Icon(
                Icons.water_drop,
                color: Color(0xFF8FD7FF),
                size: 30,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.date,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
