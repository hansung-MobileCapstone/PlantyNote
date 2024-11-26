import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../modals/cycle_setting_modal.dart';

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
  // 초기값 설정
  double waterCycle = 40; // 물 주기
  double fertilizerCycle = 3; // 영양제 주기
  double repottingCycle = 12; // 분갈이 주기

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(

              children: [
                _imagePicker(), // 식물 사진 선택
                const SizedBox(height: 25),
                _plantNameForm(), // 식물 이름 입력폼
                const SizedBox(height: 16),
                _plantSpeciesForm(), // 식물 종 입력폼
                const SizedBox(height: 16),
                _cycleModalButton(), // 주기설정 입력폼
              ],
            ),
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
      onTap: _pickImage, // 새로운 사진 선택 가능
      child: CircleAvatar(
        radius: 75,
        backgroundColor: Colors.grey[200],
        backgroundImage: _image != null
            ? FileImage(File(_image!.path)) // 이미지가 있으면 표시
            : null,
        child: _image == null
            ? Icon(
          Icons.add, // 이미지가 없을 때 추가 아이콘 표시
          color: Colors.grey[400],
          size: 30,
        )
            : null, // 이미지가 있으면 아이콘 표시 안함
      ),
    );
  }

  // 식물 이름 입력
  Widget _plantNameForm() {
    return TextFormField(
      controller: _plantNameController,
      decoration: InputDecoration(
        labelText: '식물 이름',
        hintText: '애칭을 정해주세요. (5자 이내)',
        labelStyle: TextStyle( // labelText 스타일
          color: Color(0xFF697386),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle( // hintText 스타일
          color: Color(0xFFB3B3B3),
          fontSize: 14,
        ),
        border: OutlineInputBorder( // 기본 테두리
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFFE6E6E6),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder( // 포커스
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder( // 비활성화
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFFE6E6E6),
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 15.0,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '식물의 이름을 입력하세요.';
        }
        return null;
      },
    );
  }

  // 식물 종 입력
  Widget _plantSpeciesForm() {
    return TextFormField(
      controller: _plantSpeciesController,
      decoration: InputDecoration(
        labelText: '식물 종',
        hintText: '식물의 종을 입력하세요.',
        labelStyle: TextStyle( // labelText 스타일
          color: Color(0xFF697386),
          fontSize: 14, // 글자 크기
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle( // hintText 스타일
          color: Color(0xFFB3B3B3),
          fontSize: 14, // 글자 크기
        ),
        border: OutlineInputBorder( // 기본 테두리
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFFE6E6E6),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder( // 포커스
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B), // 포커스 시에도 회색 테두리
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder( // 비활성화
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFFE6E6E6),
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 15.0,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '식물의 종을 입력하세요.';
        }
        return null;
      },
    );
  }

  // 주기 모달창 버튼
  Widget _cycleModalButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => CycleSettingModal( // 주기 모달창 호출
              initialWaterCycle: waterCycle, // 물
              initialFertilizerCycle: fertilizerCycle, // 영양체
              initialRepottingCycle: repottingCycle, // 분갈이
              onSave: (double newWaterCycle, double newFertilizerCycle, double newRepottingCycle) {
                setState(() {
                  waterCycle = newWaterCycle;
                  fertilizerCycle = newFertilizerCycle;
                  repottingCycle = newRepottingCycle;
                });
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            color: Color(0xFFECF7F2),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Color(0xFFE6E6E6),
              width: 2.0,
            ),
          ),
          child: Text(
            '물: $waterCycle일 영양제: $fertilizerCycle개월 분갈이: $repottingCycle개월',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF697386),
            ),
          ),
        ),
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
