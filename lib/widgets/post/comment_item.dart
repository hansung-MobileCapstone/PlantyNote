import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x99ECF7F2), // 배경색상
          borderRadius: BorderRadius.circular(10), // BorderRadius
        ),
        padding: const EdgeInsets.all(10.0), // 내부 패딩
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // 전체 요소 위쪽 정렬
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/sample_post.png', // 프로필 사진 경로
                width: 17, // 프로필 사진 너비
                height: 17, // 프로필 사진 높이
                fit: BoxFit.cover, // 이미지 크기 조정
              ),
            ),
            const SizedBox(width: 8), // 프로필 사진과 텍스트 간 간격
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
                children: [
                  Text(
                    "닉네임",
                    style: const TextStyle(
                      fontSize: 8, // 사용자 이름 글자 크기
                      fontWeight: FontWeight.bold, // Bold체
                      color: Colors.black, // 글자 색상
                    ),
                  ),
                  const SizedBox(height: 2), // 사용자 이름과 댓글 내용 간 간격
                  Text(
                    "이곳에 댓글 내용이 표시됩니다.",
                    style: const TextStyle(
                      fontSize: 10, // 댓글 내용 글자 크기
                      color: Colors.black87, // 댓글 내용 글자 색상
                    ),
                    textAlign: TextAlign.left, // 댓글 내용 왼쪽 정렬
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
