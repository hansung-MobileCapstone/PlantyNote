import 'package:flutter/material.dart';

// 메모 하나
class MemoItem extends StatelessWidget {
  // ------- 메모 정보 가져올때 주석 풀기
  //final String date;
  //final String content;
  //final String imageUrl;
  //final VoidCallback onTap;

  const MemoItem({super.key}
    //super.key,
    //required this.date,
    //required this.content,
    //required this.imageUrl,
    //required this.onTap,
  );

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
            ClipOval( // 식물 상태 이모지
              child: Container(
                width: 20,
                height: 20,
                color: Colors.white,
                alignment: Alignment.center,
                child: Icon(
                  Icons.sentiment_very_satisfied,
                  size: 20, // 아이콘 크기
                  color: Color(0xFFFFDE00),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text( // 작성 날짜
              "2024.10.06", // date
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
                    "메모 내용이 표시됩니다.",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  //if (imageUrl != null && imageUrl.isNotEmpty) // 메모 이미지가 있다면
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/plant1.png", //imageUrl, // 이미지 경로
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
