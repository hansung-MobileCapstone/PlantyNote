import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/components/comment_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommentModal extends StatefulWidget {
  final String docId; // 게시물의 docId를 받아오기
  final String collectionName; // posts인지 maps인지

  const CommentModal({
    Key? key,
    required this.docId,
    this.collectionName = 'posts',  // 기본값
  }) : super(key: key);

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Fluttertoast.showToast(
          msg: "로그인 후 이용해주세요",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xFF4B7E5B),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      // Firestore에서 현재 사용자 닉네임 및 프로필 이미지 가져오기
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final nickname = userDoc.data()?['nickname'] ?? '알수없음';
      final profileImageUrl = userDoc.data()?['profileImage'] ??
          'assets/images/basic_profile.png';

      // 공용 컬렉션 방식에 맞게 댓글 경로 수정
      final commentsRef = FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(widget.docId)
          .collection('comments');

      await commentsRef.add({
        'userId': user.uid,
        'nickname': nickname,
        'text': commentText,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImageUrl': profileImageUrl, // 프로필 이미지 URL 추가
      });

      _commentController.clear();

      Fluttertoast.showToast(
        msg: "댓글 추가 성공!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF4B7E5B),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "댓글 추가 실패..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF4B7E5B),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 댓글을 조회할 때도 공용 컬렉션 'posts' 아래의 해당 문서에서 가져옵니다.
    final commentsRef = FirebaseFirestore.instance
        .collection(widget.collectionName)
        .doc(widget.docId)
        .collection('comments')
        .orderBy('createdAt', descending: false);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          // 모달의 AppBar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                const Text(
                  "댓글",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 24),
                  onPressed: () {
                    context.pop(); // 모달창 닫기
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: commentsRef.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final comments = snapshot.data?.docs ?? [];

                        if (comments.isEmpty) {
                          return const Center(child: Text("댓글이 없습니다."));
                        }

                        return ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final commentData =
                            comments[index].data() as Map<String, dynamic>;
                            final userId = commentData['userId'] ?? 'Unknown';
                            final nickname = commentData['nickname'] ?? '알수없음';
                            final text = commentData['text'] ?? '';
                            final createdAt =
                            commentData['createdAt'] as Timestamp?;
                            final date = createdAt != null
                                ? "${createdAt.toDate().year}-${createdAt.toDate().month.toString().padLeft(2, '0')}-${createdAt.toDate().day.toString().padLeft(2, '0')} ${createdAt.toDate().hour.toString().padLeft(2, '0')}:${createdAt.toDate().minute.toString().padLeft(2, '0')}"
                                : 'Unknown';
                            final profileImageUrl =
                                commentData['profileImageUrl'] ?? '';

                            return CommentItem(
                              userId: userId,
                              nickname: nickname,
                              text: text,
                              date: date,
                              profileImageUrl: profileImageUrl,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _InputSection(
                      controller: _commentController,
                      onSubmit: _submitComment,
                      isSubmitting: _isSubmitting,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 입력 필드와 버튼을 구성하는 위젯
class _InputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const _InputSection({
    Key? key,
    required this.controller,
    required this.onSubmit,
    required this.isSubmitting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩 추가
        top: 5,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 85, // TextField 85%
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "댓글을 입력하세요.",
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFB3B3B3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFE6E6E6),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFE6E6E6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFF4B7E5B),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 15, // 버튼 15%
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B7E5B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(40, 40),
                padding: EdgeInsets.zero,
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              )
                  : const Center(
                child: Text(
                  "입력",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
