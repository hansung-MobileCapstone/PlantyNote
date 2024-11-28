import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF7FBF1),
      body: Stack(
        children: [
          _treeImage(screenWidth), // 트리 이미지

          Positioned( // 텍스트 박스, 로고 : 중앙 상단
            top: 150,
            left: 20,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _textBox(screenWidth), // 텍스트 박스
                _logoImage(), // 로고
              ],
            ),
          ),

          Center( // 입력 필드 (ID, PW)
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _iDInput(), // ID 입력 필드
                  const SizedBox(height: 10),
                  _pWInput(), // PW 입력 필드
                ],
              ),
            ),
          ),

          Positioned( // 로그인 버튼, 회원가입 버튼 : 중앙 하단
            bottom: 10,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _loginButton(context), // 로그인 버튼
                const SizedBox(height: 5),
                _signupButton(context), // 회원가입 버튼
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 트리 이미지
  Widget _treeImage(double screenWidth) {
    return Positioned(
      bottom: 120,
      left: screenWidth * 0.32,
      child: Opacity(
        opacity: 0.7,
        child: Image.asset(
          'assets/images/tree.png',
          width: screenWidth * 0.35,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // 로고 이미지
  Widget _logoImage() {
    return Positioned(
      top: -25,
      right: -20,
      child: Image.asset(
        'assets/images/logo.png',
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      ),
    );
  }

  // 텍스트 박스
  Widget _textBox(double screenWidth) {
    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFD2DED6),
          width: 7.0,
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
              color: Color(0xFF4B7E5B),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Login to your account',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4B7E5B),
            ),
          ),
        ],
      ),
    );
  }

  // ID 입력 필드
  Widget _iDInput() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'ID',
        hintText: '닉네임을 입력하세요.',
        labelStyle: const TextStyle(color: Color(0xFF4B7E5B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF4B7E5B),
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF4B7E5B),
            width: 3.0,
          ),
        ),
      ),
    );
  }

  // PW 입력 필드
  Widget _pWInput() {
     return TextFormField(
       obscureText: true,
       decoration: InputDecoration(
         filled: true,
         fillColor: Colors.white,
         labelText: 'PW',
         hintText: '비밀번호를 입력하세요.',
         labelStyle: const TextStyle(color: Color(0xFF4B7E5B)),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(15),
           borderSide: const BorderSide(
             color: Color(0xFF4B7E5B),
             width: 3.0,
           ),
         ),
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(15),
           borderSide: const BorderSide(
             color: Color(0xFF4B7E5B),
             width: 3.0,
           ),
         ),
       ),
     );
  }

  // 로그인 버튼
  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 회원정보가 맞다면
        context.go('/main'); // 메인페이지로 이동
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
    );
  }

  // 회원가입 버튼
  Widget _signupButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.push('/start/signup'); // 회원가입페이지로 이동
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
    );
  }
}