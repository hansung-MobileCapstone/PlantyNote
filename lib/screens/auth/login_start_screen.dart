import 'package:flutter/material.dart';

class LoginStartScreen extends StatelessWidget {
  const LoginStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 트리 배경 이미지: 온보딩 페이지와 동일한 위치
          Positioned(
            bottom: 0,
            left: 100,
            right: 0,
            child: Opacity(
              opacity: 0.7, // 투명도 조정
              child: Image.asset(
                'assets/images/tree.png',
                width: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 중앙 콘텐츠: 텍스트 박스와 로고
          Positioned(
            top: 180, // 위로 이동 (값을 낮출수록 위로 올라감)
            left: 40, // 중앙 정렬을 위해 약간 조정
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 텍스트 박스
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                ),
                // 로고: 텍스트 박스 오른쪽 위에 위치
                Positioned(
                  top: -25, // 텍스트 박스 위로 띄움
                  right: -20, // 텍스트 박스 오른쪽으로 띄움
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          // 시작하기 버튼: 중앙 하단
          Positioned(
            bottom: 170, // 기존 위치 유지
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B7E5B), // 버튼 색상 유지
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
          ),
        ],
      ),
    );
  }
}
