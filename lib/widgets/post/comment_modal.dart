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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0), // 좌우 패딩
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10, // 댓글 갯수 (예시로 10개 설정)
                itemBuilder: (context, index) {

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 85, // TextField가 9 비율
                    child: SizedBox(
                      height: 40, // TextField 높이 조정
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 13, // 텍스트 크기
                          color: Colors.black, // 텍스트 색상
                        ),
                        decoration: InputDecoration(
                          hintText: "댓글을 입력하세요.",
                          hintStyle: TextStyle(
                            fontSize: 13, // 힌트 텍스트 크기
                            color: Color(0xFFB3B3B3), // 힌트 텍스트 색상
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300, // 테두리 색상
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300, // 비활성 상태 테두리 색상
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFF4B7E5B), // 포커스 상태 테두리 색상
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, // 좌우 여백
                            vertical: 0, // 상하 여백을 없앰
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 15, // 버튼이 15% 차지
                    child: ElevatedButton(
                      onPressed: () {
                        // 버튼 클릭 동작
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B7E5B), // 버튼 배경색
                        foregroundColor: Colors.white, // 텍스트 색상
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // 둥근 버튼
                        ),
                        minimumSize: const Size(40, 40), // 최소 크기 설정
                        padding: EdgeInsets.zero, // 패딩을 없앰
                      ),
                      child: const Center(
                        child: Text(
                          "입력",
                          style: TextStyle(
                            fontSize: 11, // 텍스트 크기
                            fontWeight: FontWeight.bold, // 텍스트 굵기
                          ),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
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
