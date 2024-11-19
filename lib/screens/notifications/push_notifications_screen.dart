import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 버튼
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
        title: Text(
          '알림',
          style: TextStyle(color: Colors.black),
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
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: notification['isRead']
                  ? Colors.white // 확인된 알람은 흰색
                  : Colors.green.withOpacity(0.1), // 확인하지 않은 알람은 연녹색
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!), // 하단 경계선
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.water_drop,
                  color: Colors.blue, // 물방울 아이콘
                  size: 24,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            notification['title']!,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          Text(
                            notification['time']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification['description']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
