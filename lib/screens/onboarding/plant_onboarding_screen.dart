import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlantOnboardingScreen extends StatelessWidget {
  const PlantOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FBF1),
      body: Stack(
        children: [
          _treeImage(context), // 트리 이미지
          _logoImage(), // 로고: 오른쪽 상단
          _appInformation(), // 앱 정보: 왼쪽 상단

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  _arrowButton(context), // 계속 버튼: 중앙
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _version(), // 버전 정보: 중앙 하단
        ],
      ),
    );
  }

  // 로고 이미지
  Widget _logoImage() {
    return Positioned(
      top: 60,
      right: 30,
      child: Image.asset(
        'assets/images/logo.png',
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      ),
    );
  }

  // 트리 이미지
  Widget _treeImage(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 100,
      right: 0,
      child: Image.asset(
        'assets/images/tree.png',
        width: MediaQuery.of(context).size.width * 0.6,
        fit: BoxFit.contain,
      ),
    );
  }

  // 앱 정보
  Widget _appInformation() {
    return Positioned(
      top: 160,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'PlantyNote',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Color(0xFF434343),
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
    );
  }

  // 계속 버튼
  Widget _arrowButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go('/start'); // 로그인시작페이지로 이동
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4B7E5B),
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
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  // 버전 정보
  Widget _version() {
    return Positioned(
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
    );
  }
}
