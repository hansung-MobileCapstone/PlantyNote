import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const[
          PlantListItem(
            //context,
            plantName: '팥이',
            imageUrl: 'assets/images/sample_plant.png',
            dDayWater: 1,
            dDayFertilizer: 220,
          ),
          SizedBox(height: 16),
          PlantListItem(
            //context,
            plantName: '콩콩이',
            imageUrl: 'assets/images/sample_plant.png',
            dDayWater: 3,
            dDayFertilizer: 34,
          ),
        ],
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
