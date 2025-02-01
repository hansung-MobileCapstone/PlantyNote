import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import '../modals/comment_modal.dart';
import 'dart:io';

class PostDetailScreen extends StatefulWidget {
  final String? docId; // docId를 생성자로 받아오기

  const PostDetailScreen({super.key, this.docId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int _selectedIndex = 1; // 네비게이션바 인덱스
  int _currentImage = 0; // 현재 보여지는 사진
  bool _isLiked = false; // 하트 상태를 관리하는 변수

  Future<Map<String, dynamic>?> _fetchPostData() async {
    final user = FirebaseAuth.instance.currentUser;
    print(
        "Fetching post data for user: $user, docId: ${widget.docId}"); // 디버그 출력
    if (user == null || widget.docId == null) return null;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('posts')
        .doc(widget.docId);

    final docSnap = await docRef.get();
    if (!docSnap.exists) return null;
    return docSnap.data();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("게시물 삭제"),
          content: const Text("정말 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 모달 닫기
              },
              child: const Text("아니오"),
            ),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && widget.docId != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('posts')
                      .doc(widget.docId)
                      .delete();
                }
                Navigator.pop(context); // 모달 닫기
                context.go('/community');
              },
              child: const Text("예"),
            ),
          ],
        );
      },
    );
  }

  void _showCommentModal(BuildContext context) {
    if (widget.docId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("수정할 게시물을 찾을 수 없습니다.")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: CommentModal(docId: widget.docId!), // docId 전달
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("PostDetailScreen docId: ${widget.docId}"); // 디버그 출력
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchPostData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final post = snapshot.data;
          if (post == null) {
            return const Center(
              child: Text(
                "게시물을 찾을 수 없습니다.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final name = post['name'] ?? '사용자';
          final contents = post['contents'] ?? '';
          final images = List<String>.from(post['imageUrl'] ?? []);
          if (images.isEmpty) {
            images.add('assets/images/sample_post.png');
          }

          final details =
              List<Map<String, dynamic>>.from(post['details'] ?? []);

          // 세부 정보 추출
          final String plantSpecies = _getDetail(details, '식물 종');
          final String waterCycle = _getDetail(details, '물 주기');
          final String fertilizerCycle = _getDetail(details, '분갈이 주기');
          // final String environment = _getDetail(details, '환경'); // 환경 정보 제거

          return LayoutBuilder(
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
                            _profileSection(name),
                            const SizedBox(height: 10),
                            _postImageSlider(images),
                            const SizedBox(height: 5),
                            _postActions(),
                            _postContent(contents),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _plantDetails(waterCycle, fertilizerCycle),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // 세부 정보를 추출하는 헬퍼 함수
  String _getDetail(List<Map<String, dynamic>> details, String key) {
    for (var detail in details) {
      if (detail.containsKey(key)) {
        return detail[key] ?? '정보 없음';
      }
    }
    return '정보 없음';
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined,
              color: Color(0xFF7D7D7D), size: 24),
          onPressed: () {
            if (widget.docId != null) {
              print(
                  "Navigating to edit post with docId: ${widget.docId}"); // 디버그 출력
              context.push('/community/create', extra: {'docId': widget.docId});
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("수정할 게시물을 찾을 수 없습니다.")),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outlined,
              color: Color(0xFFDA2525), size: 24),
          onPressed: () {
            _showDeleteDialog(context);
          },
        ),
      ],
    );
  }

  Widget _profileSection(String name) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 15,
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _postImageSlider(List<String> images) {
    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          SizedBox(
            width: 380,
            height: 380,
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  _currentImage = index;
                });
              },
              children: images.map((image) {
                if (image.startsWith('http')) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (image.startsWith('assets/')) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      image,
                      fit: BoxFit.fill,
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(image), fit: BoxFit.cover),
                  );
                }
              }).toList(),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                '${_currentImage + 1}/${images.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _postActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '2024.10.04',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Row(
          children: [
            IconButton(
              icon:
                  const Icon(Icons.comment, color: Color(0xFF4B7E5B), size: 24),
              onPressed: () {
                _showCommentModal(context);
              },
            ),
            IconButton(
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

  Widget _postContent(String contents) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        contents,
        style: const TextStyle(fontSize: 13, color: Colors.black),
      ),
    );
  }

  // 식물 세부 정보 표시 (환경 정보 제거)
  Widget _plantDetails(String waterCycle, String fertilizerCycle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _informationRow('물 주기', waterCycle),
          const SizedBox(height: 8),
          _informationRow('분갈이 주기', fertilizerCycle),
          // '환경' 정보 제거
        ],
      ),
    );
  }

  // 개별 정보 행
  Widget _informationRow(String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0x804B7E5B),
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF7D7D7D),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF616161),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
