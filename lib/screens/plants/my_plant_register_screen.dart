import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../modals/cycle_setting_modal.dart';
import '../modals/calendar_modal.dart';

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
  DateTime meetingDate = DateTime.now(); // 처음 만난 날
  DateTime waterDate = DateTime.now(); // 마지막 물 준 날
  int sunlightLevel = 3; // 일조량
  int waterLevel = 3; // 물 주는 양
  double temperature = 15.0; // 온도

  @override
  void dispose() {
    _plantNameController.dispose();
    _plantSpeciesController.dispose();
    super.dispose();
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

  // Firestore에 데이터 저장
  Future<void> _submitPlantData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("로그인된 사용자가 없습니다.");
      }

      // Firestore에 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants')
          .add({
        'plantname': _plantNameController.text.trim(),
        'species': _plantSpeciesController.text.trim(),
        'waterCycle': waterCycle.toInt(),
        'fertilizerCycle': fertilizerCycle.toInt(),
        'repottingCycle': repottingCycle.toInt(),
        'sunlightLevel': sunlightLevel,
        'waterLevel': waterLevel,
        'temperature': temperature,
        'meetingDate': meetingDate.toIso8601String(),
        'waterDate': waterDate.toIso8601String(),
        'imageUrl': _image != null ? _image!.path : null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(
        msg: "식물 등록 성공!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color(0xFFECF7F2),
        textColor: Colors.black,
        fontSize: 13.0,
      );

      if (!mounted) return;
      context.pop(); // 내식물모음페이지로 이동

    } catch (e) {
      Fluttertoast.showToast(
        msg: "등록 실패..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFE81010),
        textColor: Colors.white,
      );
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
              crossAxisAlignment: CrossAxisAlignment.center, // 기본 중앙 정렬
              children: [
                _imagePicker(), // 식물 사진 선택
                const SizedBox(height: 25),
                _plantNameForm(), // 식물 이름 입력폼
                const SizedBox(height: 20),
                _plantSpeciesForm(), // 식물 종 입력폼
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "물, 영양제, 분갈이 주기",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF697386),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _cycleModalButton(), // 주기설정 입력 모달
                const SizedBox(height: 25),
                
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "식물이 좋아하는 환경",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF697386),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _plantInfoButton(),
                const SizedBox(height: 25),

                Row(
                  children: [
                    Column( // 처음 만난 날
                      children: [
                        const Text(
                          "처음 만난 날",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF697386),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _calendarModalButton(
                          selectedDate: meetingDate,
                          onDateSelected: (newDate) {
                            setState(() {
                              meetingDate = newDate;
                            });
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column( // 마지막 물 준 날 섹션
                      children: [
                        const Text(
                          "마지막 물 준 날",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF697386),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _calendarModalButton(
                          selectedDate: waterDate,
                          onDateSelected: (newDate) {
                            setState(() {
                              waterDate = newDate;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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
            '물: ${waterCycle.toInt()}일  영양제: ${fertilizerCycle.toInt()}개월  분갈이: ${repottingCycle.toInt()}개월',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF697386),
            ),
          ),
        ),
      ),
    );
  }

  // 일조량, 물주는양, 온도 설정 버튼
  Widget _plantInfoButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 일조량
          Column(
            children: [
              const Text(
                "일조량",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF697386),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "적음",
                    style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
                  ),
                  const SizedBox(width: 10), // 간격 조절
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.wb_sunny,
                          color: index < sunlightLevel
                              ? Color(0xFFFDD941)
                              : Color(0x4DFDD941),
                        ),
                        onPressed: () {
                          setState(() {
                            sunlightLevel = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "많음",
                    style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 물 주는 양
          Column(
            children: [
              const Text(
                "물 주는 양",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF697386),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "적음",
                    style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.water_drop,
                          color: index < waterLevel
                              ? Color(0xFF8FD7FF)
                              : Color(0x4D8FD7FF),
                        ),
                        onPressed: () {
                          setState(() {
                            waterLevel = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "많음",
                    style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 온도 슬라이더
          Column(
            children: [
              Text(
                "온도: ${temperature.toStringAsFixed(1)}°C",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF697386),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "-10",
                    style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
                  ),
                  SizedBox(
                    width: 250, // 슬라이더 크기
                    child: SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFFE6E6E6),
                        inactiveTrackColor: const Color(0xFFE6E6E6),
                        thumbColor: const Color(0xFF4B7E5B),
                        trackHeight: 3.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6.0,
                        ),
                        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: const Color(0xFF4B7E5B),
                        valueIndicatorTextStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        value: temperature,
                        min: -10,
                        max: 40,
                        divisions: 50,
                        label: '${temperature.toStringAsFixed(1)}°C',
                        onChanged: (value) {
                          setState(() {
                            temperature = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const Text(
                    "40",
                    style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 캘린더 모달 버튼
  Widget _calendarModalButton({
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {

    return GestureDetector(
      onTap: () {
        // 캘린더 모달 열기
        showDialog(
          context: context,
          builder: (context) => CalendarModal(
            initialDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
        );
      },
      child: Container(

        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: const Color(0xFFE6E6E6),
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.calendar_today, // 캘린더 아이콘
              size: 16,
              color: Color(0xFF697386),
            ),
          ],
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
              onPressed: () { _submitPlantData(); }, // 데이터 저장
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
