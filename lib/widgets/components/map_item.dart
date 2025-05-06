import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant/screens/modals/comment_modal.dart';
import 'package:plant/util/dateFormat.dart';

class MapItem extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  const MapItem({Key? key, required this.doc}) : super(key: key);

  @override
  State<MapItem> createState() => _MapItemState();
}

class _MapItemState extends State<MapItem> {
  late bool _isLiked; // 좋아요 상태
  late int _likeCount; // 좋아요 개수
  int _currentImage = 0; // 현재 이미지 인덱스

  @override
  void initState() {
    super.initState();
    final data = widget.doc.data()! as Map<String, dynamic>;
    _likeCount = data['likesCount'] as int? ?? 0;
    _isLiked = false;

    // 좋아요 여부 체크
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('maps')
          .doc(widget.doc.id)
          .collection('likes')
          .doc(user.uid)
          .get()
          .then((snap) {
        if (mounted) {
          setState(() {
            _isLiked = snap.exists;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.doc.data()! as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 섹션
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(data['userId'] as String)
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
          // 이미지 슬라이더
          _postImageSlider(List<String>.from(
            data['imageUrls'] as List? ?? ['assets/images/sample_post.png'],
          )),
          const SizedBox(height: 5),
          // 날짜, 댓글, 좋아요
          _postActions(
            formatDate((data['createdAt'] as Timestamp).toDate()),
          ),
          const SizedBox(height: 5),
          // 게시물 내용
          _postContent(data['contents'] as String? ?? ''),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _profileSection(String name, String profileImage) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: profileImage.startsWith('http')
                ? NetworkImage(profileImage)
                : const AssetImage('assets/images/basic_profile.png') as ImageProvider,
            radius: 15,
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
              onPageChanged: (index) => setState(() => _currentImage = index),
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

  // 날짜, 댓글, 좋아요
  Widget _postActions(String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.comment, color: Color(0xFF4B7E5B), size: 24),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => FractionallySizedBox(
                    heightFactor: 0.85,
                    child: CommentModal(
                      docId: widget.doc.id,
                      collectionName: 'maps',
                    ),
                  ),
                );
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
                if (user == null) return;
                final newState = !_isLiked;

                setState(() {
                  _isLiked = newState;
                  _likeCount += newState ? 1 : -1;
                });

                final mapRef = FirebaseFirestore.instance.collection('maps').doc(widget.doc.id);
                // 좋아요 수 업데이트
                await mapRef.update({
                  'likesCount': FieldValue.increment(newState ? 1 : -1),
                });

                // firebase 컬렉션에 좋아요 반영
                final likeDoc = mapRef.collection('likes').doc(user.uid);
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
}
