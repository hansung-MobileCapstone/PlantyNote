import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "사용자 이름",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, // 이름을 Bold 처리
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "이곳에 댓글 내용이 표시됩니다.",
                  style: TextStyle(
                    fontSize: 14, // 댓글 글자 크기
                    color: Colors.black87, // 댓글 글자 색상
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
