import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import '../modals/comment_modal.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 1; // 네비게이션바 인덱스
  int _currentImage = 0; // 현재 보여지는 사진
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(), // 상단바
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
                        _profileSection(), // 프로필
                        SizedBox(height: 10),
                        _postImageSlider(), // 이미지 슬라이더
                        SizedBox(height: 5),
                        _postActions(), // 댓글, 좋아요
                        _postContent(), // 글 내용
                      ],
                    ),
                  ),
                ),
              ),
              _plantDetails(), // 식물 상세 정보
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

  // 상단 바
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      actions: [
        IconButton( // 수정 버튼
          icon: Icon(Icons.edit, color: const Color(0xFF7D7D7D), size: 24),
          onPressed: () {
            context.push('/community/create'); // 게시물작성페이지로 이동
            // 게시물작성페이지에 현재 데이터 전달 필요 (extra)
          },
        ),
        IconButton( // 삭제 버튼
          icon: Icon(Icons.delete, color: const Color(0xFFDA2525), size: 24),
          onPressed: () {
            _showDeleteDialog(context); // 삭제 팝업 표시
          },
        ),
      ],
    );
  }

  // 삭제 확인 팝업
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("게시물 삭제"),
          content: Text("정말 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
              },
              child: Text("아니오"),
            ),
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
                context.go('/community'); // 전체게시물페이지로 이동
                // 삭제 기능 구현
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }

  // 프로필
  Widget _profileSection() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const[
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 15,
          ),
          SizedBox(width: 10),
          Text(
            '마이클',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 이미지 슬라이더
  Widget _postImageSlider() {
    return Center(
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
                  _currentImage = index;
                });
              },
              children: images.map((image) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                '${_currentImage + 1}/${images.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 작성 날짜, 댓글, 좋아요
  Widget _postActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text( // 작성 날짜
          '2024.10.04',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            IconButton( // 댓글 버튼
              icon: Icon(Icons.comment, color: const Color(0xFF4B7E5B), size: 24),
              onPressed: () {
                _showCommentModal(context); // 댓글 모달 창
              },
            ),
            IconButton( // 좋아요 버튼
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: const Color(0xFF4B7E5B),
                size: 24,
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

  // 댓글 모달 표시
  void _showCommentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 모달의 크기 조정을 위해
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85, // 화면 높이의 85%로 설정
          child: CommentModal(), // comment_modal.dart에 정의된 위젯
        );
      },
    );
  }

  // 게시물 내용
  Widget _postContent() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '선물로 받았어요.\n식물 처음 키우는데 팁 알려주세요.',
        style: TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
      ),
    );
  }

  // 식물 상세 정보 (종, 물주기, 분갈이주기, 환경)
  Widget _plantDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Wrap(
        spacing: 8,
        runSpacing: 3,
        children: details.map((detail) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0x804B7E5B),
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  detail.keys.first,
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7D7D7D),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text(
                detail.values.first,
                style: TextStyle(
                  fontSize: 10,
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
