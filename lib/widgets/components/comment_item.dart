import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final String userId;
  final String nickname;
  final String text;
  final String date;
  final String profileImageUrl; // 프로필 이미지 URL

  const CommentItem({
    Key? key,
    required this.userId,
    required this.nickname,
    required this.text,
    required this.date,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // profileImageUrl이 http로 시작하면 NetworkImage, 그렇지 않으면 AssetImage 사용
    final ImageProvider imageProvider = profileImageUrl.startsWith('http')
        ? NetworkImage(profileImageUrl)
        : AssetImage(profileImageUrl);

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
            // 프로필 이미지
            CircleAvatar(
              backgroundImage: imageProvider,
              radius: 15,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        nickname,
                        style: const TextStyle(
                          fontSize: 10,
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
                  const SizedBox(height: 3),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 12,
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
