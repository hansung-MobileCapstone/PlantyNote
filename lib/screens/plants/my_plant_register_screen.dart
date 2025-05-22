import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../modals/cycle_setting_modal.dart';
import '../modals/calendar_modal.dart';
import 'package:plant/widgets/inputs/temperature_slider.dart';
import '../../util/calculateDday.dart';

class MyPlantRegisterScreen extends StatefulWidget {
  final Map<String, dynamic>? plantData; // 수정 모드일 경우 식물 데이터를 전달받음
  final bool isEditing; // 등록 모드(false) 또는 수정 모드(true)
  final String? plantId; // 수정 모드일 경우 Firebase 문서 ID 전달받음

  const MyPlantRegisterScreen({
    Key? key,
    required this.isEditing,
    this.plantId,
    this.plantData,
  }) : super(key: key);

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
  late bool isEditing;
  late Map<String, dynamic>? plantData;

  // 초기값 설정
  double waterCycle = 40; // 물 주기
  double fertilizerCycle = 3; // 영양제 주기
  double repottingCycle = 12; // 분갈이 주기
  DateTime meetingDate = DateTime.now(); // 처음 만난 날
  DateTime waterDate = DateTime.now(); // 마지막 물 준 날
  int dDayWater = 1; // 물 d-day
  int sunlightLevel = 3; // 일조량
  int waterLevel = 3; // 물 주는 양
  double temperature = 15.0; // 온도

  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditing;
    plantData = widget.plantData;

    if (widget.isEditing && widget.plantData != null) {
      _initializeDataForEdit();
    }
  }

  // 수정 모드일 경우 데이터 초깃값
  void _initializeDataForEdit() {
    final data = widget.plantData ?? {};
    _plantNameController.text = data['plantname'] ?? '';
    _plantSpeciesController.text = data['species'] ?? '';
    waterCycle = (data['waterCycle'] ?? 40).toDouble();
    fertilizerCycle = (data['fertilizerCycle'] ?? 3).toDouble();
    repottingCycle = (data['repottingCycle'] ?? 12).toDouble();
    meetingDate =
        DateTime.parse(data['meetingDate'] ?? DateTime.now().toIso8601String());
    waterDate =
        DateTime.parse(data['waterDate'] ?? DateTime.now().toIso8601String());
    sunlightLevel = data['sunlightLevel'] ?? 3;
    waterLevel = data['waterLevel'] ?? 3;
    temperature = (data['temperature'] ?? 15).toDouble();
  }

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

      final plantCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants');

      if (widget.isEditing) {
        // 수정 모드: 기존 문서 업데이트
        await plantCollection.doc(widget.plantId).update({
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
          'dDayWater': calculateWater(waterDate, waterCycle),
          'imageUrl':
              _image != null ? _image!.path : widget.plantData?['imageUrl'],
          'updatedAt': FieldValue.serverTimestamp(),
        });

        Fluttertoast.showToast(
          msg: "식물 수정 성공!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: const Color(0xFF4B7E5B),
          textColor: Colors.white,
          fontSize: 13.0,
        );
      } else {
        // 등록 모드: 새로운 문서 추가
        await plantCollection.add({
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
          'dDayWater': calculateWater(waterDate, waterCycle),
          'imageUrl': _image != null ? _image!.path : null,
          'createdAt': FieldValue.serverTimestamp(),
          'isNotificationEnabled': true,
        });

        Fluttertoast.showToast(
          msg: "식물 등록 성공!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: const Color(0xFF4B7E5B),
          textColor: Colors.white,
          fontSize: 13.0,
        );
      }

      if (!mounted) return;
      context.go('/plants'); // 이전 화면으로 돌아가기
    } catch (e) {
      Fluttertoast.showToast(
        msg: "저장 실패: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFE81010),
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
                    Column(
                      // 처음 만난 날
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
                    Column(
                      // 마지막 물 준 날 섹션
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
        widget.isEditing ? '내 식물 수정하기' : '내 식물 등록하기',
        style: const TextStyle(
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
    return PlantImagePicker(
      image: _image,
      onTap: _pickImage,
    );
  }

  // 식물 이름 입력
  Widget _plantNameForm() {
    return TextFormField(
      controller: _plantNameController,
      decoration: InputDecoration(
        labelText: '식물 이름',
        hintText: '애칭을 정해주세요. (5자 이내)',
        labelStyle: TextStyle(
          // labelText 스타일
          color: Color(0xFF697386),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(
          // hintText 스타일
          color: Color(0xFFB3B3B3),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          // 기본 테두리
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFFE6E6E6),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          // 포커스
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          // 비활성화
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
        labelStyle: TextStyle(
          // labelText 스타일
          color: Color(0xFF697386),
          fontSize: 14, // 글자 크기
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(
          // hintText 스타일
          color: Color(0xFFB3B3B3),
          fontSize: 14, // 글자 크기
        ),
        border: OutlineInputBorder(
          // 기본 테두리
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFFE6E6E6),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          // 포커스
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B), // 포커스 시에도 회색 테두리
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          // 비활성화
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
    return CycleModalButton(
      waterCycle: waterCycle,
      fertilizerCycle: fertilizerCycle,
      repottingCycle: repottingCycle,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => CycleSettingModal(
            initialWaterCycle: waterCycle,
            initialFertilizerCycle: fertilizerCycle,
            initialRepottingCycle: repottingCycle,
            onSave: (double newWaterCycle, double newFertilizerCycle,
                double newRepottingCycle) {
              setState(() {
                waterCycle = newWaterCycle;
                fertilizerCycle = newFertilizerCycle;
                repottingCycle = newRepottingCycle;
              });
            },
          ),
        );
      },
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
          TemperatureSlider(
            temperature: temperature,
            onChanged: (value) {
              setState(() {
                temperature = value;
              });
            },
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
    return CalendarModalButton(
      selectedDate: selectedDate,
      onDateSelected: onDateSelected,
    );
  }

  // 하단 버튼 2개 (취소, 완료)
  Widget _bottomButton() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 18),
      child: Row(
        children: [
          Expanded(
            // 취소 버튼
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                context.pop();
              },
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
          Expanded(
            // 완료 버튼
            flex: 7,
            child: ElevatedButton(
              onPressed: () {
                _submitPlantData();
              }, // 데이터 저장
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

class CycleModalButton extends StatelessWidget {
  final double waterCycle;
  final double fertilizerCycle;
  final double repottingCycle;
  final VoidCallback onTap;

  const CycleModalButton({
    Key? key,
    required this.waterCycle,
    required this.fertilizerCycle,
    required this.repottingCycle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFECF7F2),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: const Color(0xFFE6E6E6),
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
}

class CalendarModalButton extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarModalButton({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
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
              Icons.calendar_today,
              size: 16,
              color: Color(0xFF697386),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantImagePicker extends StatelessWidget {
  final XFile? image;
  final VoidCallback onTap;

  const PlantImagePicker({
    Key? key,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 75,
        backgroundColor: Colors.grey[200],
        backgroundImage: image != null ? FileImage(File(image!.path)) : null,
        child: image == null
            ? Icon(
                Icons.add,
                color: Colors.grey[400],
                size: 30,
              )
            : null,
      ),
    );
  }
}
