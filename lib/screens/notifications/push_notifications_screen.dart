import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget  {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [ // 예시 데이터
    {
      'title': '콩이 물주기',
      'time': '3분 전',
      'description': '반려식물 콩이 물 줄 시간 입니다.',
      'isRead': false, // 확인하지 않은 알람
    },
    {
      'title': '팔이 물주기',
      'time': '15분 전',
      'description': '반려식물 팔이 물 줄 시간 입니다.',
      'isRead': false, // 확인하지 않은 알람
    },
    {
      'title': '팔이 물주기',
      'time': '3일 전',
      'description': '반려식물 팔이 물 줄 시간 입니다.',
      'isRead': true, // 확인된 알람
    },
    {
      'title': '콩이 물주기',
      'time': '7일 전',
      'description': '반려식물 콩이 물 줄 시간 입니다.',
      'isRead': true, // 확인된 알람
    },
  ];

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500); // 알림 제목
    final descriptionStyle = TextStyle(fontSize: 14, color: Color(0xFF747474)); // 알림 멘트
    final timeStyle = TextStyle(fontSize: 12, color: Color(0xFF7E7E7E)); // 알림 시간
    final unreadBackground = Colors.green.withOpacity(0.1); // 확인하지 않은 알림 색
    final readBackground = Colors.white; // 확인한 알림 색

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector( // 알림
            onTap: () { // 읽지 않은 알림을 누르면 팝업창 띄우기
              if (!notification['isRead']) {
                _showNotificationDialog(context, notification, index);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              color: notification['isRead'] ? readBackground : unreadBackground,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.water_drop, color: Color(0xFF8FD7FF), size: 24),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(notification['title'], style: titleStyle),
                            Spacer(),
                            Text(notification['time'], style: timeStyle),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(notification['description'], style: descriptionStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 상단바
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        '알림',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.black), // 검색 아이콘
          onPressed: () {
            // 검색 기능 추가 가능
          },
        ),
      ],
    );
  }

  // 팝업창 함수
  void _showNotificationDialog(BuildContext context, Map<String, dynamic> notification, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification['title']), // 알림 제목
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification['description']), // 알림 내용
              SizedBox(height: 10),
              Text(
                '받은 시간: ${notification['time']}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  notifications[index]['isRead'] = true; // 읽음 상태로 변경
                });
                Navigator.of(context).pop(); // 팝업창 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}

