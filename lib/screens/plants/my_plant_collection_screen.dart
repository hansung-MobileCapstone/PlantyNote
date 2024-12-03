import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import '../../widgets/components/plant_list_item.dart';

class MyPlantCollectionScreen extends StatefulWidget {
  const MyPlantCollectionScreen({super.key});
  @override
  State<MyPlantCollectionScreen> createState() => _MyPlantCollectionScreenState();
}

class _MyPlantCollectionScreenState extends State<MyPlantCollectionScreen> {
  int _selectedIndex = 0; // 네비게이션바 인덱스

  void _onItemTapped(int index) { // 인덱스 상태관리
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        // Firestore에서 식물 데이터 가져오기
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid) // 현재 로그인된 사용자
            .collection('plants')
            .snapshots(),
        builder: (context, snapshot) {
          // 로딩 스피너
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 식물이 없는 경우 안내 메시지
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "식물을 등록해 보세요!",
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          // Firestore에서 가져온 데이터
          final plants = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index]; // 개별 식물 데이터
              final plantName = plant['plantname'] ?? '식물 이름 없음'; // 식물 이름
              final imageUrl = plant['imageUrl'] ?? ''; // 이미지 URL
              final meetingDate = DateTime.parse(plant['meetingDate']); // 처음 만난 날
              final waterDate = DateTime.parse(plant['waterDate']); // 마지막 물 준 날
              final waterCycle = (plant['waterCycle'] ?? 0).toInt(); // 물 주기

              // 함께한 D-Day 계산
              final dDayTogether =
                  DateTime.now().difference(meetingDate).inDays + 1;

              // 물 주는 D-Day 계산
              final nextWaterDate = DateTime(
                waterDate.year,
                waterDate.month,
                waterDate.day,
              ).add(Duration(days: waterCycle));
              final dDayWater = nextWaterDate.difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inDays;

              // PlantListItem 위젯 생성
              return Column(
                children: [
                  PlantListItem(
                    plantName: plantName, // 식물 이름
                    imageUrl: imageUrl, // 이미지 URL
                    dDayWater: dDayWater, // 물 주는 D-Day
                    dDayFertilizer: dDayTogether, // 함께한 D-Day
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // 상단 바
  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'MY 정원',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [ // 오른쪽 끝 배치
        _writeButton(), // 식물 등록 버튼
      ],
    );
  }

  // 식물 등록 버튼 위젯
  Widget _writeButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 5, 0),
      child:
      Row(
        children: [
          Text(
            '추가',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              context.push('/plants/register'); // 내식물등록페이지로 이동
            },
            icon: Icon(
              Icons.add_circle,
              color: Color(0xFF4B7E5B),
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
