import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/components/comment_item.dart';

class CommentModal extends StatelessWidget {
  const CommentModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          // 모달의 AppBar
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
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
                    child: ListView.builder(
                      itemCount: 5, // 예시 댓글 개수
                      itemBuilder: (context, index) {
                        return CommentItem(); // 댓글 아이템 comment_item.dart
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: _InputSection(),
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

// 입력 필드, 버튼
class _InputSection extends StatelessWidget {
  const _InputSection();

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
              height: 40,
              child: TextField(
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
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
              onPressed: () {
                // 댓글 전송
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B7E5B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(40, 40), // 최소 크기
                padding: EdgeInsets.zero,
              ),
              child: const Center(
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
