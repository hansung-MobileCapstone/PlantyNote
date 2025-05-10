import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import '../modals/comment_modal.dart';
import 'package:plant/util/dateFormat.dart';

class PostDetailScreen extends StatefulWidget {
  final String? docId; // 공용 컬렉션 'posts'에 저장된 문서 ID

  const PostDetailScreen({super.key, this.docId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int _selectedIndex = 1; // 네비게이션바 인덱스
  int _currentImage = 0; // 현재 보여지는 사진 인덱스
  late bool _isLiked; // 좋아요 상태
  late int _likeCount; // 좋아요 개수

  /// 게시글과 작성자 정보를 결합하여 반환하는 함수
  Future<Map<String, dynamic>?> _fetchPostAndUserData() async {
    if (widget.docId == null) return null;
    final docRef =
    FirebaseFirestore.instance.collection('posts').doc(widget.docId);
    final docSnap = await docRef.get();
    if (!docSnap.exists) return null;
    final postData = docSnap.data()!;
    final userId = postData['userId'];
    final userSnap =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // 좋아요 상태, 개수 불러오기
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final likeDoc = await docRef.collection('likes').doc(user.uid).get();
      _isLiked = likeDoc.exists;
    }
    _likeCount = postData['likesCount'] ?? 0;

    // 결합할 데이터를 생성합니다.
    Map<String, dynamic> combined = {};
    combined.addAll(postData);
    if (userSnap.exists && userSnap.data() != null) {
      combined['user'] = userSnap.data();
    }
    return combined;
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
                if (widget.docId != null) {
                  await FirebaseFirestore.instance
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
    print("PostDetailScreen docId: ${widget.docId}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchPostAndUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final combined = snapshot.data;
          if (combined == null) {
            return const Center(
              child: Text(
                "게시물을 찾을 수 없습니다.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          // 작성자 정보는 combined['user']에 저장되어 있습니다.
          final userData =
              combined['user'] as Map<String, dynamic>? ?? <String, dynamic>{};
          final name = userData['nickname'] ?? '사용자';
          final profileImage = (userData['profileImage'] as String?)?.isNotEmpty == true
              ? userData['profileImage'] as String
              : 'assets/images/basic_profile.png';
          final contents = combined['contents'] ?? '';
          final date = formatDate((combined['createdAt'] as Timestamp).toDate());
          final images = List<String>.from(combined['imageUrl'] ?? []);
          final details =
          List<Map<String, dynamic>>.from(combined['details'] ?? []);

          // 세부 정보 추출
          final String plantSpecies = _getDetail(details, '식물 종');
          final String waterCycle = _getDetail(details, '물 주기');
          final String fertilizerCycle = _getDetail(details, '분갈이 주기');

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _profileSection(name, profileImage),
                            const SizedBox(height: 10),
                            _postImageSlider(images),
                            const SizedBox(height: 5),
                            _postActions(date),
                            _postContent(contents),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _plantDetails(plantSpecies, waterCycle, fertilizerCycle),                ],
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

  /// 세부 정보를 추출하는 헬퍼 함수
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
              print("Navigating to edit post with docId: ${widget.docId}");
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

  /// 작성자 프로필 섹션 (프로필 이미지와 닉네임 표시)
  Widget _profileSection(String name, String profileImage) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey[200],
            backgroundImage: profileImage.startsWith('http')
                ? NetworkImage(profileImage)
                : AssetImage('assets/images/basic_profile.png') as ImageProvider,
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
    if (images.isEmpty) return const SizedBox.shrink();
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

  // 날짜, 댓글, 좋아요
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
                _showCommentModal(context);
              },
            ),
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: const Color(0xFF4B7E5B),
                size: 24,
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null || widget.docId == null) return;

                final newState = !_isLiked;
                setState(() {
                  _isLiked = newState;
                  _likeCount += newState ? 1 : -1;
                });

                final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.docId);
                // 좋아요 수 업데이트
                await postRef.update({
                  'likesCount': FieldValue.increment(newState ? 1 : -1),
                });

                // firebase 컬렉션에 좋아요 반영
                final likeDoc = postRef.collection('likes').doc(user.uid);
                if (newState) {
                  await likeDoc.set({
                    'userId': user.uid,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                } else {
                  await likeDoc.delete();
                }
              },
            ),
            Text('$_likeCount'),
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

  Widget _plantDetails(String plantSpecies, String waterCycle, String fertilizerCycle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _informationRow('식물 종', plantSpecies),
          const SizedBox(height: 8),
          _informationRow('물 주기', waterCycle),
          const SizedBox(height: 8),
          _informationRow('분갈이 주기', fertilizerCycle),
        ],
      ),
    );
  }


  Widget _informationRow(String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0x804B7E5B)),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF7D7E5B)),
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
