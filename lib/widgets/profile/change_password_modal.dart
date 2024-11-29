import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordChangeModal extends StatefulWidget {
  const PasswordChangeModal({super.key});

  @override
  State<PasswordChangeModal> createState() => _PasswordChangeModalState();
}

class _PasswordChangeModalState extends State<PasswordChangeModal> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                  ),
                ),
              ],
            ),
          ],
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
