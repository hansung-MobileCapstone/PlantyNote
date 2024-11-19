import 'package:flutter/material.dart';

class CommentModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Scaffold의 배경색
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white, // AppBar 배경색
        scrolledUnderElevation: 0, // AppBar 그림자 제거
        title: const Text(
          "댓글",
          style: TextStyle(
            fontSize: 16, // 글자 크기
            fontWeight: FontWeight.bold, // 글자 굵기
            color: Colors.black, // 글자 색상
          ),
        ),
        centerTitle: true, // 텍스트 중앙 정렬
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop(); // 모달창 닫기
            },
          ),
        ],
      ),

    );
  }
}

// Main 함수
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('댓글 모달창 예제')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                builder: (context) => CommentModal(),
              );
            },
            child: const Text('모달창 열기'),
          ),
        ),
      ),
    ),
  ));
}
