import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/components/post_item.dart';

class SearchScreenResult extends StatelessWidget {
  final String keyword;

  const SearchScreenResult({super.key, required this.keyword});

  // 검색 키워드가 포함되어 있는지 확인하는 함수
  bool _containsKeyword(String text) {
    return text.toLowerCase().contains(keyword.toLowerCase());
  }

  // 키워드 강조 (볼드체 처리)
  InlineSpan _highlightText(String text) {
    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();

    if (!lowerText.contains(lowerKeyword)) {
      return TextSpan(text: text);
    }

    final spans = <TextSpan>[];
    int start = 0;
    int index;

    while ((index = lowerText.indexOf(lowerKeyword, start)) != -1) {
      if (start < index) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + keyword.length),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      start = index + keyword.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '게시물 검색 결과',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final contents = data['contents'] ?? '';
            final details = List<Map<String, dynamic>>.from(data['details'] ?? []);
            final plantSpecies = details.firstWhere(
                  (d) => d.containsKey('식물 종'),
              orElse: () => {'식물 종': ''},
            )['식물 종'];
            final userNickname = data['nickname'] ?? '';

            return _containsKeyword(contents) ||
                _containsKeyword(plantSpecies ?? '') ||
                _containsKeyword(userNickname);
          }).toList();

          if (docs.isEmpty) {
            return const Center(child: Text('검색 결과가 없습니다.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final contents = data['contents'] ?? '';
              final details = List<Map<String, dynamic>>.from(data['details'] ?? []);
              final imageUrls = List<String>.from(data['imageUrl'] ?? []);
              final userId = data['userId'] ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const SizedBox();
                  }

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final name = userData['nickname'] ?? '알 수 없음';
                  final profileImage = userData['profileImage'] ?? 'assets/images/basic_profile.png';

                  return GestureDetector(
                    onTap: () {
                      context.push('/community/detail', extra: {'docId': docId});
                    },
                    child: PostItem(
                      name: name,
                      profileImage: profileImage,
                      contents: contents,
                      imageUrls: imageUrls,
                      details: details,
                      keyword: keyword,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
