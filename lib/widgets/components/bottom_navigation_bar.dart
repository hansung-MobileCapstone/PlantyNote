import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex; // 현재 인덱스
  final Function(int) onItemTapped; // 탭 변경

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
      onTap: (index) {
        _navigatePage(context, index); // 페이지 이동
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
              Icon(Icons.menu_book, size: 32,
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

  // 페이지 이동
  void _navigatePage(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/plants'); // 내 식물 모음 페이지
        break;
      case 1:
        context.go('/main'); // 메인 페이지
        break;
      case 2:
        context.go('/profile'); // 마이 페이지
        break;
      default:
        break;
    }
  }
}
