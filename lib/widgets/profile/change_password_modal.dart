import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Fluttertoast 패키지 임포트

class PasswordChangeModal extends StatefulWidget {
  const PasswordChangeModal({super.key});

  @override
<<<<<<< HEAD
  PasswordChangeModalState createState() => PasswordChangeModalState();
}

class PasswordChangeModalState extends State<PasswordChangeModal> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  String? _currentPasswordError;
  String? _newPasswordError;

  bool _isLoading = false;

  // 비밀번호 변경 함수
  Future<void> _changePassword() async {
    setState(() {
      _currentPasswordError = null;
      _newPasswordError = null;
      _isLoading = true;
    });

    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    // 현재 사용자 가져오기
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() {
        _currentPasswordError = '사용자 정보가 없습니다. 다시 로그인해주세요.';
        _isLoading = false;
      });
      return;
    }

    // 새 비밀번호가 6자 이상인지 확인
    if (newPassword.length < 6) {
      if (!mounted) return;
      setState(() {
        _newPasswordError = '비밀번호는 최소 6자 이상이어야 합니다.';
        _isLoading = false;
      });
      return;
    }

    // 새 비밀번호가 현재 비밀번호와 동일한지 확인
    if (currentPassword == newPassword) {
      if (!mounted) return;
      setState(() {
        _newPasswordError = '현재 비밀번호와 동일합니다.';
        _isLoading = false;
      });
      return;
    }

    try {
      // 재인증을 위해 Credential 생성
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // 사용자 재인증
      await user.reauthenticateWithCredential(credential);

      // 비밀번호 업데이트
      await user.updatePassword(newPassword);

      if (!mounted) return;

      // 비밀번호 변경 완료 후 모달 닫기 및 토스트 메시지 표시
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: '비밀번호가 성공적으로 변경되었습니다.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (e.code == 'wrong-password') {
          _currentPasswordError = '올바르지 않은 비밀번호입니다.';
        } else {
          _currentPasswordError = '비밀번호 변경에 실패했습니다: ${e.message}';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _currentPasswordError = '예기치 못한 오류가 발생했습니다.';
      });
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
=======
  State<PasswordChangeModal> createState() => _PasswordChangeModalState();
}

class _PasswordChangeModalState extends State<PasswordChangeModal> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
>>>>>>> main

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
<<<<<<< HEAD
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '비밀번호 변경',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 20),
              // 현재 비밀번호 입력 필드
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.green[800]!, width: 3.5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '현재PW : 현재 비밀번호를 입력하세요.',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.green[800]),
                    border: InputBorder.none,
                  ),
                ),
              ),
              // 오류 메시지 표시
              if (_currentPasswordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _currentPasswordError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 16),
              // 변경 비밀번호 입력 필드 + 안내 텍스트
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.green[800]!, width: 3.5),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '변경PW : 새로운 비밀번호를 입력하세요.',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.green[800]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // 오류 메시지 표시
                  if (_newPasswordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        _newPasswordError!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '영문 대소문자, 숫자, 특수문자 가능.',
                      style: TextStyle(fontSize: 10, color: Colors.green[800]),
                    ),
=======
      child: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '비밀번호 변경',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            // 현재 비밀번호 입력 필드
            _currentPwForm(),
            SizedBox(height: 16),
            // 변경 비밀번호 입력 필드 + 안내 텍스트
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _newPwForm(),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '영문 대소문자, 숫자, 특수문자 가능.',
                    style: TextStyle(fontSize: 10, color: Color(0xFF4B7E5B)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Row( // 취소, 완료 버튼
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.pop(); // 모달 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE6E6E6),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    '취소',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 비밀번호 변경 로직 추가
                    context.go('/start/login'); // 로그인페이지로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4B7E5B),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    '완료',
                    style: TextStyle(fontWeight: FontWeight.bold),
>>>>>>> main
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 버튼들
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(fontSize: 16, color: Colors.green[800]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      '완료',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 현재 비밀번호 입력
  Widget _currentPwForm() {
    return TextFormField(
      controller: _currentPwController,
      decoration: InputDecoration(
        labelText: '현재 PW',
        hintText: '현재 비밀번호를 입력하세요.',
        labelStyle: TextStyle( // labelText 스타일
          color: Color(0xFF697386),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle( // hintText 스타일
          color: Color(0xFFB3B3B3),
          fontSize: 14,
        ),
        border: OutlineInputBorder( // 기본 테두리
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder( // 포커스
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder( // 비활성화
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 15.0,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '현재 비밀번호를 올바르게 입력하세요.';
        }
        return null;
      },
    );
  }

  // 현재 비밀번호 입력
  Widget _newPwForm() {
    return TextFormField(
      controller: _newPwController,
      decoration: InputDecoration(
        labelText: '변경 PW',
        hintText: '새로운 비밀번호를 입력하세요.',
        labelStyle: TextStyle( // labelText 스타일
          color: Color(0xFF697386),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle( // hintText 스타일
          color: Color(0xFFB3B3B3),
          fontSize: 14,
        ),
        border: OutlineInputBorder( // 기본 테두리
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder( // 포커스
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder( // 비활성화
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 15.0,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '새로운 비밀번호를 입력하세요.';
        }
        return null;
      },
    );
  }
}
