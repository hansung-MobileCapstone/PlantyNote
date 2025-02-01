import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final String userId;
  final String nickname;
  final String text;
  final String date;

  const CommentItem({
    super.key,
    required this.userId,
    required this.nickname,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        nickname,
                        style: const TextStyle(
                          fontSize: 10, // 고정된 이름 글씨 크기
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3), // 이름과 댓글 간격
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 12, // 고정된 댓글 글씨 크기
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
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
