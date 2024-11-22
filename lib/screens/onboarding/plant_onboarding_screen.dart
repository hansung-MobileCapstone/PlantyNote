import 'package:flutter/material.dart';

class PlantOnboardingScreen extends StatelessWidget {
  const PlantOnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 트리 배경 이미지: 화면 하단 중앙 배치
          Positioned(
            bottom: 0,
            left: 100,
            right: 0,
            child: Image.asset(
              'assets/images/tree.png',
              width: MediaQuery.of(context).size.width * 0.6, // 너비 조정
              fit: BoxFit.contain, // 비율 유지
            ),
          ),
          // 로고: 화면 오른쪽 상단 배치
          Positioned(
            top: 60,
            right: 30,
            child: Image.asset(
              'assets/images/logo.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          // 텍스트를 왼쪽 상단에 배치
          Positioned(
            top: 160,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
              children: const [
                Text(
                  'PlantyNote',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic, // 이탤릭 적용
                    color: Color(0xFF434343), // 텍스트 색상 변경
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '식물 성장을 위한 모든 비법과 계획,\n다양한 사용자들의 이야기까지\n모든 게 준비되어 있습니다.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // 중앙 정렬된 UI
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
                children: [
                  const SizedBox(height: 60), // 여백 추가
                  // 계속 버튼
                  ElevatedButton(
                    onPressed: () {
                      // login_start_screen.dart로 이동
                      Navigator.pushNamed(context, '/loginStart');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4B7E5B), // 버튼 색상 변경
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          '계속 ',
                          style: TextStyle(fontSize: 17, color: Colors.white), // 버튼 텍스트 색상 변경
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white), // 아이콘 색상 변경
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // 버전 정보: 화면 하단 중앙
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: const Text(
              'version 1.1.2',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
