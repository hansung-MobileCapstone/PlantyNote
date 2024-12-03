import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

// 내 식물 하나
class PlantListItem extends StatelessWidget {
  final String plantName;
  final String imageUrl;
  final int dDayWater;
  final int dDayFertilizer;

  const PlantListItem({
    super.key,
    required this.plantName,
    required this.imageUrl,
    required this.dDayWater,
    required this.dDayFertilizer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/plants/timeline'); // 내식물타임라인페이지로 이동(/$id 추가)
      },
      child: SizedBox(
        height: 130, // Card 높이 고정
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          color: const Color(0xFFF5F5F5),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _plantName(), // 식물 이름
                ),
                const SizedBox(width: 8), // 이름과 이미지 사이 간격
                _plantImage(context), // 식물 이미지
                const SizedBox(width: 8), // 이미지와 D-Day 사이 간격
                Expanded(
                  child: _dDay(), // D-Day
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 식물 이름 (왼쪽)
  Widget _plantName() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        plantName,
        style: const TextStyle(
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
        softWrap: true, // 개행 허용
      ),
    );
  }

  // 식물 이미지, 물주기 버튼 (중앙)
  Widget _plantImage(BuildContext context) {
    final file = File(imageUrl);

    return Container(
      alignment: Alignment.center, // 이미지 항상 가운데
      child: Stack(
        alignment: Alignment.center, // 기본 정렬: 중앙
        children: [
          // 중앙: 식물 이미지
          CircleAvatar(
            radius: 55,
            backgroundImage: imageUrl.isNotEmpty && File(imageUrl).existsSync()
                ? FileImage(File(imageUrl)) // 로컬 파일 이미지
                : AssetImage('assets/images/default_post.png') as ImageProvider, // 기본 이미지
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              width: 30, // 버튼 크기
              height: 30,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF), // 배경색
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.water_drop,
                  color: Color(0xFF8FD7FF),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  _showWateringDialog(context); // 팝업창
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 팝업창 표시 함수
  void _showWateringDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          title: Text("물 주기"),
          content: Text("$plantName에게 물을 주시겠습니까?"),
          actions: [
            // 아니오 버튼
            TextButton(
              onPressed: () { context.pop(); }, // 팝업 닫기
              child: const Text("아니오"),
            ),
            // 예 버튼
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
                // 물주기 로직 추가
                _showToast("$plantName에게 물을 주었습니다!");
              },
              child: const Text("예"),
            ),
          ],
        );
      },
    );
  }

  // 토스트 메시지 표시 함수
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // 지속 시간
      gravity: ToastGravity.CENTER, // 위치
      backgroundColor: Color(0xFFECF7F2),
      textColor: Colors.black,
      fontSize: 13.0,
    );
  }

  // D-Day (오른쪽)
  Widget _dDay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _dDayBadge('D+$dDayFertilizer', Color(0xFFE7B4BA)),
        const SizedBox(height: 8),
        _dDayBadge('D-$dDayWater', Color(0xFF95CED5)),
      ],
    );
  }

  // D-Day 뱃지
  Widget _dDayBadge(String text, Color color) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical:4, horizontal:0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5), // 테두리 색상
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
