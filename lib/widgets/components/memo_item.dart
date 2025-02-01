import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

// 메모 하나
class MemoItem extends StatelessWidget {
  final String date; // 작성 날짜
  final String content; // 메모 내용
  final String imageUrl; // 이미지 경로
  final int emojiIndex; // 이모지 인덱스
  final String memoId; // 메모 ID
  final String plantId; // 식물 ID

  const MemoItem({
    super.key,
    required this.date,
    required this.content,
    required this.imageUrl,
    required this.emojiIndex,
    required this.memoId,
    required this.plantId,
  });

  Future<void> _deleteMemo(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Fluttertoast.showToast(
        msg: "로그인된 사용자가 없습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try { // firebase에서 삭제
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants')
          .doc(plantId)
          .collection('memos')
          .doc(memoId)
          .delete();

      Fluttertoast.showToast(
        msg: "메모 삭제 성공",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color(0xFF4B7E5B),
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "메모 삭제 실패..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const emojis = ['😆', '😊', '😐', '😞', '😭'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x99ECF7F2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval( // 식물 상태 이모지
              child: Container(
                width: 20,
                height: 20,
                color: Color(0x99ECF7F2),
                alignment: Alignment.center,
                child: Text(
                  emojis[emojiIndex],
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text( // 작성 날짜
              date, // date
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text( // 메모 내용
                    content,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  if (imageUrl != null && imageUrl.isNotEmpty) // 메모 이미지가 있다면
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(imageUrl), // 이미지 경로
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
            IconButton( // 삭제 버튼
              icon: const Icon(Icons.delete_outline, color: Color(0xFFDA2525), size: 16),
              onPressed: () {
                _showDeleteDialog(context); // 삭제 확인 팝업
              },
            ),
          ],
        ),
      ),
    );
  }

  // 삭제 확인 팝업
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("메모 삭제"),
          content: Text("정말 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
              },
              child: Text("아니오"),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                _deleteMemo(context);
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }
}
