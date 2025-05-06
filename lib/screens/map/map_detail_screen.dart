import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import 'package:plant/widgets/components/map_item.dart';

class MapDetailScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot> docList; // 해당 문서 리스트
  const MapDetailScreen({Key? key, required this.docList}) : super(key: key);

  @override
  State<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends State<MapDetailScreen> {
  int _selectedIndex = 2; // 네비게이션바 인덱스

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 위치 및 게시물 개수
            _locationBox(),
            // 게시물 목록
            for (var doc in widget.docList) ...[
              const Divider(height: 1),
              const SizedBox(height: 10),
              MapItem(doc: doc), // MapItem 컴포넌트
            ],
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        '우리 동네 식물 지도',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 위치 및 게시물 개수
  Widget _locationBox() {
    // 첫 번째 문서의 address
    final firstData = widget.docList.first.data() as Map<String, dynamic>;
    final address = firstData['address'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF4B7E5B)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.description, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  '게시물 수 ${widget.docList.length}개',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
