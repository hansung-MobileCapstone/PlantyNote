import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostCreateScreen extends StatefulWidget {
  final String? docId; // 수정 모드일 경우 docId를 받습니다.

  const PostCreateScreen({super.key, this.docId});

  @override
  PostCreateScreenState createState() => PostCreateScreenState();
}

class PostCreateScreenState extends State<PostCreateScreen> {
  final List<XFile?> _images = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  String? _selectedPlantName;
  List<String> _plantNames = ['선택안함']; // 초기값 최소화

  String? _docId; // 수정 모드 docId
  Map<String, dynamic>? _editingPost;

  @override
  void initState() {
    super.initState();
    _docId = widget.docId; // widget.docId로 설정
    print("PostCreateScreen initState with docId: $_docId"); // 디버그 출력
    _loadEditingData();
    _fetchUserPlants(); // 내 식물 목록 가져오기
  }

  Future<void> _fetchUserPlants() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plants')
        .get();

    List<String> plantNames = ['선택안함'];
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final plantName = data['plantname'] ?? '';
      if (plantName.isNotEmpty) {
        plantNames.add(plantName);
      }
    }

    setState(() {
      _plantNames = plantNames;
    });
  }

  Future<void> _loadEditingData() async {
    if (_docId == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('posts')
        .doc(_docId);

    final docSnap = await docRef.get();
    if (docSnap.exists) {
      _editingPost = docSnap.data();
      _textController.text = _editingPost?['contents'] ?? '';
      final details =
      List<Map<String, dynamic>>.from(_editingPost?['details'] ?? []);
      if (details.isNotEmpty && details[0].containsKey('식물 종')) {
        _selectedPlantName = details[0]['식물 종'];
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(
        msg: "수정할 게시물을 찾을 수 없습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF812727), // 배경색
        textColor: Colors.white, // 글자 색
        fontSize: 16.0,
      );
      if (mounted) context.pop();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submitPost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: "로그인 후 이용해주세요",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF812727), // 배경색
        textColor: Colors.white, // 글자 색
        fontSize: 16.0,
      );
      return;
    }

    // 더 이상 사용자 닉네임이나 프로필 이미지를 저장하지 않습니다.
    // 대신 게시글에는 userId만 저장해서, 나중에 게시글을 표시할 때 최신 사용자 정보를 가져올 수 있습니다.

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      const Center(child: CircularProgressIndicator()),
    );

    try {
      List<String> newImageUrls = [];
      for (var img in _images) {
        if (img != null) {
          final fileName =
              '${DateTime.now().millisecondsSinceEpoch}_${img.name}';
          final storageRef =
          FirebaseStorage.instance.ref('post_images/$fileName');
          await storageRef.putFile(File(img.path));
          final downloadUrl = await storageRef.getDownloadURL();
          newImageUrls.add(downloadUrl);
        }
      }

      // 선택한 식물의 정보를 가져오기
      String selectedPlantName = _selectedPlantName ?? '선택안함';
      Map<String, dynamic>? plantData;

      if (selectedPlantName != '선택안함') {
        final plantQuery = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('plants')
            .where('plantname', isEqualTo: selectedPlantName)
            .limit(1)
            .get();

        if (plantQuery.docs.isNotEmpty) {
          plantData = plantQuery.docs.first.data();
        }
      }

      // 'details' 필드 구성 (환경 필드 제거)
      final details = [
        {'식물 종': selectedPlantName},
        {
          '물 주기': plantData?['waterCycle']?.toString() ?? '정보 없음'
        },
        {
          '분갈이 주기':
          plantData?['fertilizerCycle']?.toString() ?? '정보 없음'
        },
      ];

      // 디버그 출력
      print("Selected Plant Name: $selectedPlantName");
      print("Plant Data: $plantData");
      print("Details: $details");

      final postsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('posts');

      if (_docId != null) {
        // 수정 모드: 기존 게시글 업데이트 (userId는 변하지 않으므로 변경하지 않습니다.)
        final docRef = postsRef.doc(_docId);
        final docSnap = await docRef.get();
        if (!docSnap.exists) {
          context.pop();
          Fluttertoast.showToast(
            msg: "게시물을 찾을 수 없습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color(0xFF812727),
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        final existingImages =
        List<String>.from(docSnap.data()?['imageUrl'] ?? []);
        final updatedImages =
        newImageUrls.isNotEmpty ? newImageUrls : existingImages;

        await docRef.update({
          'contents': _textController.text.trim(),
          'imageUrl': updatedImages,
          'details': details,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) Navigator.pop(context);
        if (mounted) context.pop({'docId': _docId, 'action': 'update'});
      } else {
        // 신규 작성: 사용자 정보를 별도로 저장하지 않고, userId만 저장합니다.
        final newDoc = await postsRef.add({
          'userId': user.uid,
          'contents': _textController.text.trim(),
          'imageUrl': newImageUrls,
          'details': details,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        print("New post created with docId: ${newDoc.id}");

        if (mounted) Navigator.pop(context); // 로딩 닫기
        if (mounted) context.pop({'docId': newDoc.id});
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // 로딩 닫기
      Fluttertoast.showToast(
        msg: "등록 실패..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF812727),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
              Align(
                alignment: Alignment.centerRight,
                child: _dropdownSelector(),
              ),
              const SizedBox(height: 16.0),
              _imagePicker(),
              const SizedBox(height: 10),
              const Divider(
                color: Color(0xFF4B7E5B),
                thickness: 0.5,
              ),
              const SizedBox(height: 10),
              _inputField(),
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
        '게시물 작성',
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

  Widget _dropdownSelector() {
    return Container(
      height: 25,
      padding: const EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFB3B3B3)),
        borderRadius: BorderRadius.circular(50),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPlantName,
          hint: const Text('식물 이름', style: TextStyle(fontSize: 12)),
          items: _plantNames.map((name) {
            return DropdownMenuItem(
              value: name,
              child: Text(name, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPlantName = value;
            });
          },
          icon: const Icon(Icons.arrow_drop_down),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

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
                    child:
                    const Icon(Icons.close, size: 15, color: Colors.white),
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

  Widget _inputField() {
    return TextField(
      controller: _textController,
      maxLines: null,
      minLines: 15,
      decoration: InputDecoration(
        hintText: '당신의 식물 이야기를 들려주세요!',
        hintStyle:
        const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0xFFB3B3B3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0xFF4B7E5B), width: 1),
        ),
      ),
      style: const TextStyle(fontSize: 13, color: Colors.black),
    );
  }

  Widget _bottomButton() {
    return Container(
      color: Colors.white,
      padding:
      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
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
