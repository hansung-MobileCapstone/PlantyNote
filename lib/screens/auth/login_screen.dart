import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(); // 이메일 입력 컨트롤러
  final TextEditingController _passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러
  final _formKey = GlobalKey<FormState>(); // 폼의 상태를 관리하기 위한 키
  String _errorMessage = ''; // 에러 메시지 저장

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF1),
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

          Center( // 입력 필드 (Email, PW)
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _emailInput(), // Email 입력 필드
                    const SizedBox(height: 10),
                    _pWInput(), // PW 입력 필드
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 0),
                        child: Align(
                          alignment: Alignment.centerLeft, // 오른쪽 정렬
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                  ],
                ),
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

  // Email 입력 필드
  Widget _emailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Email',
        hintText: '이메일을 입력하세요.',
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '이메일을 입력하세요.';
        }
        // 이메일 형식 검사
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return '유효한 이메일 주소를 입력하세요.';
        }
        return null;
      },
    );
  }

  // PW 입력 필드
  Widget _pWInput() {
    return TextFormField(
      controller: _passwordController,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '비밀번호를 입력하세요.';
        }
        return null;
      },
    );
  }

  // 로그인 버튼
  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _login,
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

  // 로그인 함수
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase Authentication을 사용하여 로그인
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // 로그인 성공 시 메인 페이지로 이동
        if (!mounted) return;
        context.go('/main');

      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          setState(() {
            _errorMessage = '올바르지 않은 비밀번호입니다.';
          });
        } else if (e.code == 'user-not-found') {
          setState(() {
            _errorMessage = '등록되지 않은 이메일입니다.';
          });
        } else {
          setState(() {
            _errorMessage = '로그인에 실패했습니다. (${e.code})';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = '로그인에 실패했습니다.';
        });
      }
    }
  }
}
