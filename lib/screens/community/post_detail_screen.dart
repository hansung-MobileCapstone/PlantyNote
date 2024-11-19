import 'package:flutter/material.dart';
import '../../widgets/components/bottom_navigation_bar.dart';

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

  // 예제 이미지 데이터
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
    // 화면 크기 비율 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = (screenWidth / 400 + screenHeight / 800) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24 * scaleFactor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: const Color(0xFF7D7D7D), size: 24 * scaleFactor),
            onPressed: () {
              // 수정 기능
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: const Color(0xFFDA2525), size: 24 * scaleFactor),
            onPressed: () {
              // 삭제 기능
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
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileSection(scaleFactor), // 프로필
                        SizedBox(height: 10 * scaleFactor),
                        _postImageSlider(scaleFactor), // 이미지 슬라이더
                        SizedBox(height: 5 * scaleFactor),
                        _postActions(scaleFactor), // 댓글, 좋아요
                        _postContent(scaleFactor), // 글 내용
                      ],
                    ),
                  ),
                ),
              ),
              _plantDetails(scaleFactor), // 식물 상세 정보
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

  // 프로필
  Widget _profileSection(double scaleFactor) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 15 * scaleFactor,
          ),
          SizedBox(width: 10 * scaleFactor),
          Text(
            '마이클',
            style: TextStyle(
              fontSize: 15 * scaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 이미지 슬라이더
  Widget _postImageSlider(double scaleFactor) {
    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          SizedBox(
            width: 380 * scaleFactor,
            height: 380 * scaleFactor,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: images.map((image) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10 * scaleFactor),
                  child: Image.asset(
                    image,
                    fit: BoxFit.fill,
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 8 * scaleFactor,
            right: 8 * scaleFactor,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8 * scaleFactor,
                vertical: 4 * scaleFactor,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(50 * scaleFactor),
              ),
              child: Text(
                '${_currentPage + 1}/${images.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12 * scaleFactor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 작성 날짜, 댓글, 좋아요
  Widget _postActions(double scaleFactor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '2024.10.04',
          style: TextStyle(
            fontSize: 10 * scaleFactor,
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.comment, color: const Color(0xFF4B7E5B), size: 24 * scaleFactor),
              onPressed: () {
                // 댓글 기능
              },
            ),
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: const Color(0xFF4B7E5B),
                size: 24 * scaleFactor,
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
    );
  }

  // 게시물 내용
  Widget _postContent(double scaleFactor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '선물로 받았어요.\n식물 처음 키우는데 팁 알려주세요.',
        style: TextStyle(
          fontSize: 13 * scaleFactor,
          color: Colors.black,
        ),
      ),
    );
  }

  // 식물 상세 정보 (종, 물주기, 분갈이주기, 환경)
  Widget _plantDetails(double scaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10 * scaleFactor,
        horizontal: 3 * scaleFactor,
      ),
      child: Wrap(
        spacing: 8 * scaleFactor,
        runSpacing: 3 * scaleFactor,
        children: details.map((detail) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 7 * scaleFactor,
                  vertical: 2 * scaleFactor,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0x804B7E5B),
                  ),
                  borderRadius: BorderRadius.circular(50 * scaleFactor),
                ),
                child: Text(
                  detail.keys.first,
                  style: TextStyle(
                    fontSize: 10 * scaleFactor,
                    color: Color(0xFF7D7D7D),
                  ),
                ),
              ),
              SizedBox(width: 5 * scaleFactor),
              Text(
                detail.values.first,
                style: TextStyle(
                  fontSize: 10 * scaleFactor,
                  color: Color(0xFF616161),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
