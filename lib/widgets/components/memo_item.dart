import 'package:flutter/material.dart';
import 'dart:io';

// 메모 하나
class MemoItem extends StatelessWidget {
  final String date; // 작성 날짜
  final String content; // 메모 내용
  final String imageUrl; // 이미지 경로
  final int emojiIndex; // 이모지 인덱스
  //final VoidCallback onTap;

  const MemoItem({
    super.key,
    required this.date,
    required this.content,
    required this.imageUrl,
    required this.emojiIndex,
    //required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const emojis = ['😆', '😊', '😐', '😞', '😭'];
    final file = File(imageUrl);

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
            ClipOval( // 식물 상태 이모지
              child: Container(
                width: 20,
                height: 20,
                color: Color(0x99ECF7F2),
                alignment: Alignment.center,
                child: Text(
                  emojis[emojiIndex],
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text( // 작성 날짜
              date, // date
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text( // 메모 내용
                    content,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  if (imageUrl != null && imageUrl.isNotEmpty) // 메모 이미지가 있다면
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(imageUrl), // 이미지 경로
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
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
