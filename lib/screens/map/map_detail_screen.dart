import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
//import '../modals/comment_modal.dart';

class MapDetailScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot> docList; // 해당 문서 리스트
  const MapDetailScreen({Key? key, required this.docList}) : super(key: key);

  @override
  State<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends State<MapDetailScreen> {
  int _selectedIndex = 2; // 네비게이션바 인덱스
  int _currentImage = 0; // 현재 보여지는 사진 인덱스
  bool _isLiked = false; // 좋아요 상태

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 위치 및 게시물 개수
            _locationBox(),
            // 게시물 목록
            for (var doc in widget.docList) ...[
              const Divider(height: 1),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 사용자 정보 로드
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc((doc.data()! as Map<String, dynamic>)['userId'])
                          .get(),
                      builder: (context, userSnap) {
                        if (userSnap.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            height: 30,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (!userSnap.hasData || !userSnap.data!.exists) {
                          return _profileSection('사용자 없음', '');
                        }
                        final userData = userSnap.data!.data()! as Map<String, dynamic>;
                        return _profileSection(
                          userData['nickname'] as String? ?? '사용자',
                          userData['profileImage'] as String? ?? '',
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _postImageSlider( // 올린 사진들
                      List<String>.from(
                        (doc.data()! as Map<String, dynamic>)['imageUrls'] ??
                            ['assets/images/sample_post.png'],
                      ),
                    ),
                    const SizedBox(height: 5),
                    _postActions( // 날짜
                      _formatDate(
                        (doc.data()! as Map<String, dynamic>)['createdAt']
                            .toDate(),
                      ),
                    ),
                    const SizedBox(height: 5),
                    _postContent( // 게시물 내용
                      (doc.data()! as Map<String, dynamic>)['contents']
                      as String? ??
                          '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        '우리 동네 식물 지도',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 위치 및 게시물 개수
  Widget _locationBox() {
    // 첫 번째 문서의 address
    final firstData = widget.docList.first.data() as Map<String, dynamic>;
    final address = firstData['address'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF4B7E5B)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.description, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  '게시물 수 ${widget.docList.length}개',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 작성자 프로필 (프로필 이미지와 닉네임)
  Widget _profileSection(String name, String profileImage) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: profileImage.startsWith('http')
                ? NetworkImage(profileImage)
                : const AssetImage('assets/images/profile.png') as ImageProvider,
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

  // 이미지 슬라이더
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
                    child: Image.network(image, fit: BoxFit.cover),
                  );
                } else if (image.startsWith('assets/')) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(image, fit: BoxFit.fill),
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
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  // 댓글, 하트 아이콘
  Widget _postActions(String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.comment, color: Color(0xFF4B7E5B), size: 24),
              onPressed: () {
                //_showCommentModal(context);
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

  // 게시물 내용
  Widget _postContent(String contents) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        contents,
        style: const TextStyle(fontSize: 13, color: Colors.black),
      ),
    );
  }

  // Timestamp -> yyyy-MM-dd 포맷
  String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
