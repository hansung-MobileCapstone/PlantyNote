import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x99ECF7F2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/sample_post.png', // 프로필 사진
                width: 17, // 고정된 이미지 크기
                height: 17,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8), // 프로필과 이름 간격
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "닉네임",
                    style: TextStyle(
                      fontSize: 8, // 고정된 이름 글씨 크기
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2), // 이름과 댓글 간격
                  const Text(
                    "이곳에 댓글 내용이 표시됩니다.",
                    style: TextStyle(
                      fontSize: 10, // 고정된 댓글 글씨 크기
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.left,
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
