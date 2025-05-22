import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Fluttertoast 패키지 임포트
import 'package:go_router/go_router.dart'; // GoRouter 패키지 임포트

class PasswordChangeModal extends StatefulWidget {
  const PasswordChangeModal({super.key});

  @override
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
      context.pop(); // 변경된 부분
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              // 현재 비밀번호 입력 필드
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF4B7E5B), width: 2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '현재PW : 현재 비밀번호를 입력하세요.',
                    hintStyle: TextStyle(fontSize: 12, color: Color(0x994B7E5B)),
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF4B7E5B), width: 2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '변경PW : 새로운 비밀번호를 입력하세요.',
                        hintStyle: TextStyle(fontSize: 12, color: Color(0x994B7E5B)),
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
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE6E6E6),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      elevation: 0,
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B7E5B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      elevation: 0, // 그림자 제거
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      '완료',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
}
