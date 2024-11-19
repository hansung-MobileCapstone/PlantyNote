import 'package:flutter/material.dart';
import './comment_item.dart';

class CommentModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          "댓글",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true, // 중앙 정렬
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop(); // 모달창 닫기
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5, // 댓글 개수
                itemBuilder: (context, index) {
                  return CommentItem();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: _inputSection(),
            ),
          ],
        ),
      ),
    );
  }

  // 입력 필드, 버튼
  Widget _inputSection() {
    return Row(
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
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFB3B3B3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFF4B7E5B),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 15, // 입력 버튼 15%
          child: ElevatedButton(
            onPressed: () {
              // 버튼 동작
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
    );
  }
}
