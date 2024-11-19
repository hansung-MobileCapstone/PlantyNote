import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String name;
  final String contents;
  final List<String> imageUrls;
  final List<Map<String, String>> details;

  const PostItem({
    Key? key,
    required this.name,
    required this.contents,
    required this.imageUrls,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130, // Card 높이 고정
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        color: const Color(0xFFF5F5F5),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 게시물 사진
              if (imageUrls.isNotEmpty)
                Container(
                  width: 100,

                  child: Stack(
                    children: [
                      // 두 번째 이미지 (뒤에 배치)
                      if (imageUrls.length > 1)
                        Positioned(
                          left: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrls[1],
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      // 첫 번째 이미지
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrls[0],
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: 12),

              // 텍스트 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar( // 프로필 사진
                          radius: 10,
                          backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                        ),
                        const SizedBox(width: 8),
                        Text( // 이름
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contents, // 게시물 내용
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7D7D7D),
                      ),
                      maxLines: 3, // 3줄까지 표시
                      overflow: TextOverflow.ellipsis, // 내용이 길면 ...으로
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              // 세로선
              Container(
                width: 1,
                height: 95,
                color: const Color(0xFF7D7D7D),
              ),
              SizedBox(width: 8),

              // 식물 상세 정보 (식물종, 물주기, 분갈이주기, 환경)
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: details.map((detail) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0x804B7E5B),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              detail.keys.first,
                              style: const TextStyle(
                                fontSize: 7,
                                color: Color(0xFF7D7D7D),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            detail.values.first,
                            style: const TextStyle(
                              fontSize: 7,
                              color: Color(0xFF616161),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
