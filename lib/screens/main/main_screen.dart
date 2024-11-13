import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: _logoImage(),
          centerTitle: true, // 중앙 배치
          actions: [
            IconButton( // 푸시 알림 페이지
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // 상단 로고 위젯
  Widget _logoImage() {
    return Row(
      mainAxisSize: MainAxisSize.min, // 크기를 내용에 맞춤
      crossAxisAlignment: CrossAxisAlignment.center, // 가로축 정렬
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 32, // 로고 크기를 조정
        ),
        SizedBox(width: 7), // 로고와 텍스트 간격
        Text('PlantyNote',
          style: TextStyle(
            fontSize: 23,
            color: Color(0xFF434343),
            fontWeight: FontWeight.bold, // Bold 적용
            fontStyle: FontStyle.italic, // Italic 적용
          ),
        ),
      ],
    );
  }
}
