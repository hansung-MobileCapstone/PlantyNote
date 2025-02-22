import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import '../../widgets/components/post_item.dart';

class AllPostsScreen extends StatefulWidget {
  const AllPostsScreen({super.key});

  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  int _selectedIndex = 1; // 네비게이션바 인덱스

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // 로그인 안된 경우
      return const Scaffold(
        body: Center(child: Text("로그인 후 이용해주세요.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "게시물이 없습니다. 글을 작성해보세요!",
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final postData = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              // 게시물에는 사용자 ID만 저장되어 있음
              final userId = postData['userId'];
              final contents = postData['contents'] ?? '';
              final imageUrls = List<String>.from(postData['imageUrl'] ?? []);
              final details = List<Map<String, dynamic>>.from(postData['details'] ?? []);

              // 사용자 ID를 이용해 최신 사용자 정보를 가져옴
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!userSnapshot.hasData || userSnapshot.data?.data() == null) {
                    return const Center(child: Text("사용자 정보를 불러오지 못했습니다."));
                  }
                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final name = userData['nickname'] ?? '알 수 없음';
                  final profileImage = userData['profileImage'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      // docId 전달 및 디버그 출력
                      print("Clicked post with docId: $docId");
                      context.push('/community/detail', extra: {'docId': docId});
                    },
                    child: PostItem(
                      name: name,
                      profileImage: profileImage,
                      contents: contents,
                      imageUrls: imageUrls,
                      details: details,
                    ),
                  );
                },
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

  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        '전체 게시물',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _writeButton(),
      ],
    );
  }

  Widget _writeButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 5, 0),
      child: Row(
        children: [
          const Text(
            '글 쓰기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              context.push('/community/create');
            },
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xFF4B7E5B),
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
