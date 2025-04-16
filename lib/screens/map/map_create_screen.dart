import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class MapCreateScreen extends StatefulWidget {
  final String? mapId;
  const MapCreateScreen({super.key, this.mapId});

  @override
  MapCreateScreenState createState() => MapCreateScreenState();
}

class MapCreateScreenState extends State<MapCreateScreen> {
  final List<XFile?> _images = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  // 이미지 선택
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  // 이미지 삭제
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // 식물 게시
  Future<void> _submitPost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: "로그인 후 이용해주세요",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF812727),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // 로딩 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _imagePicker(), // 이미지 선택
              const SizedBox(height: 10),
              const Divider(
                color: Color(0xFF4B7E5B),
                thickness: 0.5,
              ),
              const SizedBox(height: 8),
              Row( // 위치 선택 버튼
                children: [
                  _setLocationButton(
                    icon: Icons.my_location,
                    label: '현재 위치 불러오기',
                    onPressed: () { },
                  ),
                  SizedBox(width: 12),
                  _setLocationButton(
                    icon: Icons.pin_drop,
                    label: '지도에서 선택',
                    onPressed: () { },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(" 설정 위치: 서울특별시 성북구 보문로 168", // 설정 위치
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _inputField(), // 입력 필드
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        '우리동네 식물 등록',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  // 위치 설정 버튼
  Widget _setLocationButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFFB3B3B3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
      icon: Icon(icon, color: Color(0xFFB3B3B3)),
      label: Text(
        label,
        style: TextStyle(
            color: Colors.black,
            fontSize: 13,
        ),
      ),
    );
  }

  // 이미지 선택
  Widget _imagePicker() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._images.asMap().entries.map((entry) {
          int index = entry.key;
          XFile? image = entry.value;
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(image!.path),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
        if (_images.length < 3)
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add, color: Colors.grey[400]),
            ),
          ),
      ],
    );
  }

  // 입력 필드
  Widget _inputField() {
    return TextField(
      controller: _textController,
      maxLines: null,
      minLines: 15,
      decoration: InputDecoration(
        hintText: '동네에서 발견한 식물을 자랑해주세요!',
        hintStyle: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFB3B3B3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4B7E5B), width: 1),
        ),
      ),
      style: const TextStyle(fontSize: 13, color: Colors.black),
    );
  }

  // 취소, 완료 버튼
  Widget _bottomButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6E6E6),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('취소'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 7,
            child: ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B7E5B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('완료'),
            ),
          ),
        ],
      ),
    );
  }
}
