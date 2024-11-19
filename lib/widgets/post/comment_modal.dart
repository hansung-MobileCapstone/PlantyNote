import 'package:flutter/material.dart';
import './comment_item.dart';

class CommentModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 화면 크기 비율 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = (screenWidth / 400 + screenHeight / 800) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          "댓글",
          style: TextStyle(
            fontSize: 16 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true, // 중앙 정렬
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black, size: 24 * scaleFactor),
            onPressed: () {
              Navigator.of(context).pop(); // 모달창 닫기
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15 * scaleFactor),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5, // 댓글 개수
                itemBuilder: (context, index) {
                  return CommentItem(scaleFactor: scaleFactor);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0 * scaleFactor),
              child: _inputSection(scaleFactor),
            ),
          ],
        ),
      ),
    );
  }

  // 입력 필드, 버튼
  Widget _inputSection(double scaleFactor) {
    return Row(
      children: [
        Expanded(
          flex: 85, // TextField 85%
          child: SizedBox(
            height: 40 * scaleFactor,
            child: TextField(
              style: TextStyle(
                fontSize: 13 * scaleFactor,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "댓글을 입력하세요.",
                hintStyle: TextStyle(
                  fontSize: 13 * scaleFactor,
                  color: const Color(0xFFB3B3B3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20 * scaleFactor),
                  borderSide: const BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20 * scaleFactor),
                  borderSide: const BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20 * scaleFactor),
                  borderSide: const BorderSide(
                    color: Color(0xFF4B7E5B),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10 * scaleFactor,
                  vertical: 10 * scaleFactor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8 * scaleFactor),
        Expanded(
          flex: 15, // 버튼 15%
          child: ElevatedButton(
            onPressed: () {
              // 버튼 동작
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B7E5B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20 * scaleFactor),
              ),
              minimumSize: Size(40 * scaleFactor, 40 * scaleFactor), // 최소 크기
              padding: EdgeInsets.zero,
            ),
            child: Center(
              child: Text(
                "입력",
                style: TextStyle(
                  fontSize: 11 * scaleFactor,
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
