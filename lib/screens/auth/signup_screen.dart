import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //에러 메세지 저장
  String _nicknameError = '';
  String _emailError = '';
  String _passwordError = '';

  @override
  void initState() {
    super.initState();

    // 닉네임 컨트롤러에 리스너 추가
    _nicknameController.addListener(() {
      if (_nicknameError.isNotEmpty) {
        setState(() {
          _nicknameError = '';
        });
      }
    });

    // 이메일 컨트롤러에 리스너 추가
    _emailController.addListener(() {
      if (_emailError.isNotEmpty) {
        setState(() {
          _emailError = '';
        });
      }
    });

    // 비밀번호 컨트롤러에 리스너 추가
    _passwordController.addListener(() {
      if (_passwordError.isNotEmpty) {
        setState(() {
          _passwordError = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

          Center( // 입력 필드 (ID, Email, PW)
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 120),
                    _iDInput(), // ID 입력 필드
                    SizedBox(height: 10),
                    _eMailInput(), // Email 입력 필드
                    SizedBox(height: 10),
                    _pWInput(), // PW 입력 필드if (_errorMessage.isNotEmpty)
                  ],
                ),
              ),
            ),
          ),
          Positioned( // 회원가입 버튼 : 중앙 하단
            bottom: 63,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _signupButton(context),
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
            'SIGN UP',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B7E5B),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Create your new account',
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
      controller: _nicknameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'ID',
        hintText: '닉네임을 입력하세요 (10자 이내)',
        errorText: _nicknameError.isNotEmpty ? _nicknameError : null, // 오류 메시지 추가
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
          return '닉네임을 입력하세요.';
        }
        if (value.length > 10) {
          return '닉네임은 10자 이내여야 합니다.';
        }
        // 특수문자 검사
        if (!RegExp(r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]+$').hasMatch(value)) {
          return '특수문자는 입력할 수 없습니다.';
        }
        return null;
      },
    );
  }

  // Email 입력 필드
  Widget _eMailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Email',
        hintText: 'user@mail.com',
        errorText: _emailError.isNotEmpty ? _emailError : null, // 오류 메시지 추가
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
          return '이메일 형식으로 입력하세요.';
        }
        return null;
      },
    );
  }

  // PW 입력 필드
  Widget _pWInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'PW',
            hintText: '비밀번호를 입력하세요.',
            errorText: _passwordError.isNotEmpty ? _passwordError : null, // 오류 메시지 추가
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
            if (value.length < 6) {
              return '비밀번호는 6자 이상이어야 합니다.';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: const Text(
            '영문 대소문자, 숫자, 특수문자 가능',
            style: TextStyle(fontSize: 12, color: Color(0xFF93B29D)),
          ),
        ),
      ],
    );
  }

  // 회원가입 버튼
  Widget _signupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // 이전 오류 메시지 초기화
          setState(() {
            _nicknameError = '';
            _emailError = '';
            _passwordError = '';
          });
          // 회원가입 처리 로직
          await _signup();
        }
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
        '회원가입',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Future<void> _signup() async {
    String nickname = _nicknameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // 닉네임 중복 확인
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        // 닉네임이 이미 존재함
        if (!mounted) return;
        setState(() {
          _nicknameError = '중복된 닉네임입니다.';
        });
        return;
      }

      // 이메일과 비밀번호로 회원가입
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 추가 정보 Firestore에 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'nickname': nickname,
        'email': email,
        'bio': '안녕하세요', // 소개문은 '안녕하세요'로 저장
      });

      // 회원가입 성공 시 에러 메시지 초기화
      if (!mounted) return;
      setState(() {
        _nicknameError = '';
        _emailError = '';
        _passwordError = '';
      });

      // 회원가입 성공 토스트 메시지 표시
      Fluttertoast.showToast(
        msg: "회원가입 성공!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFF4B7E5B), // 배경색 설정
        textColor: Colors.white, // 글자 색 설정
        fontSize: 16.0,
      );

      // 로그인 페이지로 이동
      context.go('/start/login');

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        if (e.code == 'email-already-in-use') {
          _emailError = '이미 사용 중인 이메일입니다.';
        } else if (e.code == 'weak-password') {
          _passwordError = '비밀번호는 6자 이상이어야 합니다.';
        } else {
          _emailError = '회원가입에 실패했습니다. (${e.code})';
        }
      });
    } catch (e) {
      if (!mounted) return;
      // 기타 예외 처리
    }
  }
}