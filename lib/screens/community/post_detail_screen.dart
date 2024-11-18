import 'package:flutter/material.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import '../community/all_posts_screen.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 1; // 네비게이션바 인덱스
  int _currentPage = 0;
  bool _isLiked = false; // 하트 상태를 관리하는 변수

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 예제 이미지 데이터 (사용자가 올린 이미지의 개수)
  final List<String> images = [
    'assets/images/sample_post.png',
    'assets/images/sample_post.png',
    'assets/images/sample_post.png',
  ];

  // 예제 식물 상세 정보
  final List<Map<String, String>> details = [
    {'식물 종': '선인장'},
    {'물 주기': '7일에 한번'},
    {'분갈이 주기': '3년'},
    {'환경': '19-27°C'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: const Color(0xFF7D7D7D)),
            onPressed: () {
              // 수정 기능 구현
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: const Color(0xFFDA2525)),
            onPressed: () {
              // 삭제 기능 구현
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 프로필 사진과 사용자 이름
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/profile.png'),
                                radius: 15,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                '마이클',
                                style: TextStyle(
                                  fontSize: 15,
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
                                width: 380,
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
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: Image.asset(
                                        image,
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
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
                                    borderRadius:
                                    BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    '${_currentPage + 1}/${images.length}',
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
                              '2024.10.04',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.comment,
                                      color: const Color(0xFF4B7E5B)),
                                  onPressed: () {
                                    // 댓글 기능 구현
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: const Color(0xFF4B7E5B),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLiked = !_isLiked;
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
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),

              // 식물 상세 정보
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10, horizontal:3), // bottomNavigationBar와 간격 유지
                child: Wrap(
                  spacing: 8,
                  runSpacing: 3,
                  children: details.map((detail) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
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
                              fontSize: 10,
                              color: Color(0xFF7D7D7D),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          detail.values.first,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF616161),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
