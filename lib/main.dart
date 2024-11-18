import 'package:flutter/material.dart';
import 'screens/profile/my_page_screen.dart'; // MyPageScreen 파일 경로

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyPageScreen(), // 시작 화면 설정
    );
  }
}
