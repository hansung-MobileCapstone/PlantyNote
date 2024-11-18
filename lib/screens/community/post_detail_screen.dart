import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLiked = false; // 하트 상태를 관리하는 변수

  // 예제 이미지 데이터 (사용자가 올린 이미지의 개수)
  final List<String> images = [
    'assets/images/sample_post.png',
    'assets/images/sample_post.png',
    'assets/images/sample_post.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색 설정
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // 아이콘 색상 변경
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: const Color(0xFF7D7D7D)), // 편집 아이콘 색상
            onPressed: () {
              // 수정 기능 구현
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: const Color(0xFFDA2525)), // 삭제 아이콘 색상
            onPressed: () {
              // 삭제 기능 구현
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Body 배경색 설정
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 사진과 사용자 이름
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Row가 자식 크기에 맞춰짐
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/profile.png'), // 프로필 이미지 경로
                        radius: 15, // 프로필 사진 크기 줄이기
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '마이클',
                        style: TextStyle(
                          fontSize: 15, // 사용자 이름 글꼴 크기
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 게시물 이미지 (슬라이드 기능 + BorderRadius)
                Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        width: 380, // 정사각형 크기
                        height: 380,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: images.map((image) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10), // 둥근 모서리
                              child: Image.asset(
                                image,
                                fit: BoxFit.fill,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // 이미지 인덱스 표시
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(50), // 둥근 모서리 (50)
                          ),
                          child: Text(
                            '${_currentPage + 1}/${images.length}', // 총 이미지 개수 반영
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 작성 날짜, 댓글, 좋아요 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '2024.10.04', // 작성 날짜
                      style: const TextStyle(
                        fontSize: 10, // 작성 날짜 글꼴 크기
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.comment, color: const Color(0xFF4B7E5B)), // 댓글 아이콘 색상
                          onPressed: () {
                            // 댓글 기능 구현
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFF4B7E5B),
                          ),
                          onPressed: () {
                            setState(() {
                              _isLiked = !_isLiked; // 하트 상태 변경
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                // 글 내용
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '선물로 받았어요.\n식물 처음 키우는데 팁 알려주세요.',
                    style: TextStyle(
                      fontSize: 13, // 글 내용 글꼴 크기
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
