import 'package:flutter/material.dart';

import '../../screens/main/main_screen.dart';
import '../../screens/plants/my_plant_collection_screen.dart';
import '../../screens/profile/my_page_screen.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex; // 현재 인덱스
  final Function(int) onItemTapped; // 인덱스 변경 시

  const MyBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0, // 그림자 제거
      currentIndex: selectedIndex,
      onTap: (index) { // 페이지 이동
        _navigatePage(context, index);
        onItemTapped(index); // 상태 업데이트
      },
      items: [
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _greenBar(visible: selectedIndex == 0),
              Icon(Icons.eco, size: 32,
                  color: selectedIndex == 0 ? Colors.grey : Colors.grey[400]),
            ],
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _greenBar(visible: selectedIndex == 1),
              Icon(Icons.book, size: 32,
                  color: selectedIndex == 1 ? Colors.grey : Colors.grey[400]),
            ],
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _greenBar(visible: selectedIndex == 2),
              Icon(Icons.person, size: 32,
                  color: selectedIndex == 2 ? Colors.grey : Colors.grey[400]),
            ],
          ),
          label: '',
        ),
      ],
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey[400],
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }

  // 현재 선택된 인덱스 표시 (초록색 바)
  Widget _greenBar({required bool visible}) {
    if (!visible) return SizedBox.shrink(); // false면 빈 위젯
    return Container(
      height: 3,
      width: 80,
      color: Color(0xFF4B7E5B),
      margin: EdgeInsets.only(bottom: 5),
    );
  }

  // 페이지 이동 로직 함수
  void _navigatePage(BuildContext context, int index) {
    Widget targetPage;

    if (index == 0) {
      targetPage = MainScreen(); // 식물 모음 페이지 클래스명으로 바꾸시면 됩니다.
    } else if (index == 1) {
      targetPage = MainScreen(); // 메인 페이지
    } else if (index == 2) {
      targetPage = MyPageScreen(); // 마이 페이지 클래스명으로 바꾸시면 됩니다.
    } else {
      return; // 예외 상황
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }
}
