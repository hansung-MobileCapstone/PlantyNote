import 'package:flutter/material.dart';
import 'package:plant/screens/profile/my_page_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: 'Plant App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyPageScreen(), // MyPageScreen을 첫 화면으로 설정
    );
  }
}
