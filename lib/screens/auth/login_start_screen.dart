import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginStartScreen extends StatelessWidget {
  const LoginStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF7FBF1),
      body: Stack(
        children: [
          _treeImage(screenWidth), // 트리 이미지

          Positioned( // 텍스트 박스, 로고: 중앙
            top: 180,
            left: 40,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _textBox(screenWidth), // 텍스트 박스
                _logoImage(), // 로고: 텍스트 박스 오른쪽 위
              ],
            ),
          ),

          _startButton(context), // 시작하기 버튼: 중앙 하단
        ],
      ),
    );
  }

  // 로고 이미지
  Widget _logoImage() {
    return Positioned(
      top: -25, // 텍스트 박스 위로 띄움
      right: -20, // 텍스트 박스 오른쪽으로 띄움
      child: Image.asset(
        'assets/images/logo.png',
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      ),
    );
  }

  // 트리 이미지
  Widget _treeImage(double screenWidth) {
    return Positioned(
      bottom: 0,
      left: 100,
      right: 0,
      child: Opacity(
        opacity: 0.7, // 투명도 조정
        child: Image.asset(
          'assets/images/tree.png',
          width: screenWidth * 0.6,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // 텍스트 박스
  Widget _textBox(double screenWidth) {
    return Container(
      width: screenWidth * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFD2DED6), // 보더 색상 변경
          width: 7.0, // 보더 두께 유지
        ),
      ),
      child: const Text(
        'The best\napp for\nyour plants',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4B7E5B), // 텍스트 색상
        ),
      ),
    );
  }

  // 시작하기 버튼
  Widget _startButton(BuildContext context) {
    return Positioned(
      bottom: 170, // 기존 위치 유지
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/start/login'); // 로그인페이지로 이동
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4B7E5B),
            padding: const EdgeInsets.symmetric(
              horizontal: 100,
              vertical: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            '시작하기',
            style: TextStyle(fontSize: 23, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
