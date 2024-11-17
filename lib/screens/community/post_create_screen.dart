import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // File 클래스 사용을 위한 import

class PostCreateScreen extends StatefulWidget {
  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          '게시물 작성',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // 가운데 정렬
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  // 취소, 완료 버튼
  Widget _bottomButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE6E6E6), // 취소 버튼 배경색
                foregroundColor: Colors.black, // 취소 버튼 텍스트 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('취소'),
            ),
          ),
          SizedBox(width: 10), // 버튼 간격
          Expanded(
            flex: 7,
            child: ElevatedButton(
              onPressed: () {
                // 완료 버튼 동작 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B7E5B), // 완료 버튼 배경색
                foregroundColor: Colors.white, // 완료 버튼 텍스트 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('완료'),
            ),
          ),
        ],
      ),
    );
  }

}
