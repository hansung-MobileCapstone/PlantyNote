import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/ConfirmDialog.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import '../modals/comment_modal.dart';
import 'package:plant/util/dateFormat.dart';

class PostDetailScreen extends StatefulWidget {
  final String? docId;

  const PostDetailScreen({super.key, this.docId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int _selectedIndex = 1;
  int _currentImage = 0;
  late PageController _pageController;
  bool _isLiked = false;
  int _likeCount = 0;
  Map<String, dynamic>? _postData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadPostData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadPostData() async {
    if (widget.docId == null) return;
    final docRef = FirebaseFirestore.instance.collection('posts').doc(widget.docId);
    final docSnap = await docRef.get();
    if (!docSnap.exists) return;
    final data = docSnap.data()!;
    final userId = data['userId'];

    final userSnap = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userSnap.data();

    final currentUser = FirebaseAuth.instance.currentUser;
    bool isLiked = false;
    if (currentUser != null) {
      final likeDoc = await docRef.collection('likes').doc(currentUser.uid).get();
      isLiked = likeDoc.exists;
    }

    setState(() {
      _postData = {
        ...data,
        'user': userData,
      };
      _isLiked = isLiked;
      _likeCount = data['likesCount'] ?? 0;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: '게시물 삭제',
        content: '정말 삭제하시겠습니까?',
        onConfirm: () {
          Navigator.pop(context, true);
        },
      ),
    ).then((confirmed) async {
      if (confirmed == true && widget.docId != null) {
        await FirebaseFirestore.instance.collection('posts').doc(widget.docId).delete();
        if (context.mounted) {
          context.go('/community');
        }
      }
    });
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
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: CommentModal(docId: widget.docId!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _postData == null
          ? const Center(child: Text("게시물을 찾을 수 없습니다."))
          : LayoutBuilder(
        builder: (context, constraints) {
          final userData = _postData!['user'] ?? {};
          final name = userData['nickname'] ?? '사용자';
          final profileImage = (userData['profileImage'] as String?)?.isNotEmpty == true
              ? userData['profileImage']
              : 'assets/images/basic_profile.png';
          final contents = _postData!['contents'] ?? '';
          final date = formatDate((_postData!['createdAt'] as Timestamp).toDate());
          final images = List<String>.from(_postData!['imageUrl'] ?? []);
          final details = List<Map<String, dynamic>>.from(_postData!['details'] ?? []);

          final plantSpecies = _getDetail(details, '식물 종');
          final waterCycle = _getDetail(details, '물 주기');
          final fertilizerCycle = _getDetail(details, '분갈이 주기');

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
              _plantDetails(plantSpecies, waterCycle, fertilizerCycle),
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
          icon: const Icon(Icons.edit_outlined, color: Color(0xFF7D7D7D), size: 24),
          onPressed: () {
            if (widget.docId != null) {
              context.push('/community/create', extra: {'docId': widget.docId});
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("수정할 게시물을 찾을 수 없습니다.")),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outlined, color: Color(0xFFDA2525), size: 24),
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

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
                : AssetImage(profileImage) as ImageProvider,
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentImage = index);
                print('현재 이미지 인덱스: $index'); // 디버깅 출력
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

  Widget _postActions(String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.comment, color: Color(0xFF4B7E5B), size: 24),
              onPressed: () => _showCommentModal(context),
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
                await postRef.update({
                  'likesCount': FieldValue.increment(newState ? 1 : -1),
                });

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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _informationRow('식물 종', plantSpecies),
          const SizedBox(width: 10),
          _informationRow('물 주기', waterCycle),
          const SizedBox(width: 10),
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
          style: const TextStyle(fontSize: 10, color: Color(0xFF616161), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
