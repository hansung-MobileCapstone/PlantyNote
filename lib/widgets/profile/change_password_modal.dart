import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordChangeModal extends StatelessWidget {
  const PasswordChangeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                fontSize: 22,
              ),
            ),
            SizedBox(height: 20),
            // 현재 비밀번호 입력 필드
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green[800]!, width: 3.5), // 초록색 선 굵기 설정
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '현재PW : 현재 비밀번호를 입력하세요.',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.green[800]),
                  border: InputBorder.none,
                ),
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
                    border: Border.all(color: Colors.green[800]!, width: 3.5), // 초록색 선 굵기 설정
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextField(

                    decoration: InputDecoration(
                      hintText: '변경PW : 새로운 비밀번호를 입력하세요.',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.green[800]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 4), // 필드와 안내 텍스트 간격
                Align(
                  alignment: Alignment.centerRight, // 텍스트를 오른쪽으로 정렬
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
                    context.pop(); // 모달 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14), // 버튼 크기 증가
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
                  onPressed: () {
                    // 비밀번호 변경 로직 추가
                    context.go('/start/login'); // 로그인페이지로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14), // 버튼 크기 증가
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text(
                    '완료',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
