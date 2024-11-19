import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final double scaleFactor;

  const CommentItem({required this.scaleFactor});

  @override
  Widget build(BuildContext context) {
    final imageSize = 17 * scaleFactor;
    final nameFontSize = 8 * scaleFactor;
    final commentFontSize = 10 * scaleFactor;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5 * scaleFactor),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x99ECF7F2),
          borderRadius: BorderRadius.circular(10 * scaleFactor),
        ),
        padding: EdgeInsets.all(10 * scaleFactor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/sample_post.png', // 프로필 사진
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8 * scaleFactor), // 프로필과 이름 간격
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "닉네임",
                    style: TextStyle(
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2 * scaleFactor), // 이름과 댓글 간격
                  Text(
                    "이곳에 댓글 내용이 표시됩니다.",
                    style: TextStyle(
                      fontSize: commentFontSize,
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
