import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyPlantRegisterScreen extends StatefulWidget {
  const MyPlantRegisterScreen({super.key});

  @override
  State<MyPlantRegisterScreen> createState() => _MyPlantRegisterScreenState();
}

class _MyPlantRegisterScreenState extends State<MyPlantRegisterScreen> {
  XFile? _image; // 이미지 저장 변수
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _plantNameController = TextEditingController();
  final _plantSpeciesController = TextEditingController();
  bool isError = false;
  bool isImageUploaded = false;

  @override
  void dispose() {
    _plantNameController.dispose();
    _plantSpeciesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() {
      isError = !_formKey.currentState!.validate();
    });
    if (!isError) {
      // 완료 처리
    }
  }

  // 사진 선택 함수
  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  // 사진 업로드 로직 추가
                  setState(() {
                    isImageUploaded = true;
                  });
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _imagePicker(),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      //_inputField(),
                    ],
                  ),
                ),
                // child: Container(
                //   width: double.infinity,
                //   height: 150,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Center(
                //     child: isImageUploaded
                //         ? const Icon(Icons.check, size: 32, color: Colors.green)
                //         : const Text('사진 추가 (10MB 이하)'),
                //   ),
                // ),
              ),
              if (!isImageUploaded && isError)
                const Text(
                  '사진 용량 초과',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plantNameController,
                decoration: const InputDecoration(
                  labelText: '식물 이름',
                  hintText: '애칭을 정해주세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '식물의 이름을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plantSpeciesController,
                decoration: const InputDecoration(
                  labelText: '식물 종',
                  hintText: '식물의 종을 입력하세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '식물의 종을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  // 상단 바
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        '내 식물 등록하기',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false, // 뒤로가기버튼 숨기기
    );
  }

  // 사진 등록 ImagePicker
  Widget _imagePicker() {
    return GestureDetector(
      onTap: _pickImage, // 클릭 시 새로운 사진 선택 가능
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
          image: _image != null
              ? DecorationImage(
            image: FileImage(File(_image!.path)),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _image == null
            ? Icon(
          Icons.add,
          color: Colors.grey[400],
          size: 30,
        )
            : null, // 이미지가 있으면 아이콘 표시 안함
      ),
    );
  }

  // 하단 버튼 2개 (취소, 완료)
  Widget _bottomButton() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Row(
        children: [
          Expanded( // 취소 버튼
            flex: 3,
            child: ElevatedButton(
              onPressed: () { context.pop(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE6E6E6),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('취소'),
            ),
          ),
          SizedBox(width: 10),
          Expanded( // 완료 버튼
            flex: 7,
            child: ElevatedButton(
              onPressed: () { context.pop(); }, // 데이터 전달 필요
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B7E5B),
                foregroundColor: Colors.white,
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
