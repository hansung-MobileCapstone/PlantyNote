import 'package:flutter/material.dart';
//import '../../widgets/components/bottom_navigation_bar.dart';

class AllPostsScreen extends StatefulWidget {
  const AllPostsScreen({super.key});

  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  int _selectedIndex = 1; // 네비게이션바 인덱스

  void _onItemTapped(int index) { // 인덱스 상태관리
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar( // 상단바
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            '전체 게시물',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            _titleBar(),
          ],
        ),

      ),
    );
  }

  // 글 쓰기 버튼 위젯
  Widget _titleBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 5, 0),
      child:
      Row(
        children: [
          const Text(
            '글 쓰기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {}, // 글쓰기 버튼 클릭 이벤트
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xFF4B7E5B),
              size: 35,
            ),
          ),
        ],
      ),
    );
  }




}