import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/components/notificaiton_item.dart';
import '../../util/LocalNotification.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatefulWidget  {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  // 알림 목록
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // 알림 목록 불러오기, 배열에 저장
  void _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // SharedPreferences에서 알림 목록 불러오기
    List<String>? storedNotifications = prefs.getStringList('notifications_$userId');
    List<Map<String, dynamic>> loadedNotifications = [];

    if (storedNotifications != null) {
      for (var notificationData in storedNotifications) {
        // 알림 데이터를 파싱(날짜, 제목, 내용, 읽음여부)
        var notificationParts = notificationData.split('|');
        if (notificationParts.length == 5) {
          loadedNotifications.add({
            'title': notificationParts[1],
            'date': notificationParts[0],
            'message': notificationParts[2],
            'isRead': notificationParts[4] == 'read', // "unread" or "read"
          });
        }
      }
    }

    setState(() {
      notifications = loadedNotifications;
    });
  }

  // 읽음 상태가 변경되었을 때 호출되는 함수
  void _onReadStatusChanged(int index, bool isRead) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // SharedPreferences에 상태 저장
    List<String>? storedNotifications = prefs.getStringList('notifications_$userId');
    if (storedNotifications != null) {
      String notification = storedNotifications[index];
      List<String> notificationParts = notification.split('|');

      // 읽음으로 변경
      notificationParts[4] = isRead ? 'read' : 'unread';
      storedNotifications[index] = notificationParts.join('|');

      prefs.setStringList('notifications_$userId', storedNotifications);
    }

    setState(() {
      notifications[index]['isRead'] = isRead;
    });
  }

  // 삭제 확인 팝업
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림 지우기"),
          content: Text("모든 알림을 삭제합니다."),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
              },
              child: Text("아니오"),
            ),
            TextButton(
              onPressed: () {
                LocalNotification.clearAllSharedPreferences();
                context.pop(); // 팝업 닫기
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationItem(
            title: notifications[index]['title']!,
            date: notifications[index]['date']!,
            message: notifications[index]['message']!,
            isRead: notifications[index]['isRead']!,
            onReadStatusChanged: (isRead) => _onReadStatusChanged(index, isRead),
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
        IconButton( // 삭제 버튼
          icon: const Icon(
              Icons.delete_outlined, color: Color(0xFFDA2525), size: 24),
          onPressed: () {
            _showDeleteDialog(context); // 삭제 팝업 표시
          },
        ),
      ],
    );
  }
}

