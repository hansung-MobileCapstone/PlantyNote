import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final String userId;
  final String text;
  final String date;

  const CommentItem({
    super.key,
    required this.userId,
    required this.text,
    required this.date,
  });

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
            // 프로필 이미지를 제거했습니다.
            // 필요하다면 여기에 다른 위젯을 추가할 수 있습니다.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userId,
                    style: const TextStyle(
                      fontSize: 8, // 고정된 이름 글씨 크기
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2), // 이름과 댓글 간격
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 10, // 고정된 댓글 글씨 크기
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                    ),
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
