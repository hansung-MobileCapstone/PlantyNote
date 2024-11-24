import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 트리 배경 이미지
          Positioned(
            bottom: 120,
            left: MediaQuery.of(context).size.width * 0.32,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/tree.png',
                width: MediaQuery.of(context).size.width * 0.35, // 크기를 더 줄임
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 중앙 콘텐츠: 텍스트 박스와 로고
          Positioned(
            top: 150,
            left: 20,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 텍스트 박스
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFD2DED6), // 보더 색상
                      width: 7.0, // 보더 두께
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B7E5B), // 텍스트 색상
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Login to your account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4B7E5B), // 텍스트 색상
                        ),
                      ),
                    ],
                  ),
                ),
                // 로고
                Positioned(
                  top: -25,
                  right: -20,
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
          // 입력 필드
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ID 입력 필드
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true, // 배경색 활성화
                      fillColor: Colors.white, // 배경색 흰색으로 설정
                      labelText: 'ID',
                      hintText: '닉네임을 입력하세요.',
                      labelStyle: const TextStyle(color: Color(0xFF4B7E5B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF4B7E5B),
                          width: 3.0, // 보더 두께 증가
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF4B7E5B),
                          width: 3.0, // 보더 두께 증가
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // PW 입력 필드
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true, // 배경색 활성화
                      fillColor: Colors.white, // 배경색 흰색으로 설정
                      labelText: 'PW',
                      hintText: '비밀번호를 입력하세요.',
                      labelStyle: const TextStyle(color: Color(0xFF4B7E5B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF4B7E5B),
                          width: 3.0, // 보더 두께 증가
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF4B7E5B),
                          width: 3.0, // 보더 두께 증가
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 로그인 버튼과 텍스트: 중앙 하단
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/main');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B7E5B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 150,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Don\'t have account? ',
                      style: TextStyle(fontSize:18, color: Color(0xFFB7C7C2)),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: Color(0xFF4B7E5B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}