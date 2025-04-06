import 'package:flutter/material.dart';
import 'dart:io';

// 게시물 하나를 나타내는 위젯
class PostItem extends StatelessWidget {
  final String name;
  final String profileImage;
  final String contents;
  final List<String> imageUrls;
  final List<Map<String, dynamic>> details;

  const PostItem({
    super.key,
    required this.name,
    required this.profileImage,
    required this.contents,
    required this.imageUrls,
    required this.details,
  });

  // 세부 정보를 추출하는 헬퍼 함수
  String _getDetail(String key) {
    for (var detail in details) {
      if (detail.containsKey(key)) {
        return detail[key] ?? '정보 없음';
      }
    }
    return '정보 없음';
  }

  // imageUrl이 asset 경로인지, 네트워크 URL인지 체크하는 헬퍼 함수
  Widget _buildImage(String imageUrl, {double width = 90, double height = 90}) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
  }

  // 게시글에 등록된 이미지를 표시하는 위젯
  Widget _postImage() {
    return SizedBox(
      width: 100,
      child: Stack(
        children: [
          if (imageUrls.length > 1)
            Positioned(
              left: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildImage(imageUrls[1]),
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrls.isNotEmpty
                ? _buildImage(imageUrls[0])
                : _buildImage(
                'https://res.cloudinary.com/heyset/image/upload/v1689582418/buukmenow-folder/no-image-icon-0.jpg'),
          ),
        ],
      ),
    );
  }

  // 게시글 내용을 표시하는 위젯
  Widget _postContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          contents,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF7D7D7D),
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // 식물 정보를 표시하는 위젯
  Widget _plantInformation(String plantSpecies, String waterCycle, String fertilizerCycle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
      children: [
        _informationRow('식물 종', plantSpecies),
        const SizedBox(height: 8),
        _informationRow('물 주기', waterCycle),
        const SizedBox(height: 8),
        _informationRow('분갈이 주기', fertilizerCycle),
      ],
    );
  }

  // 개별 정보 행을 표시하는 위젯
  Widget _informationRow(String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0x804B7E5B),
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 7,
              color: Color(0xFF7D7D7D),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 7,
            color: Color(0xFF616161),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 세부 정보 추출
    final String plantSpecies = _getDetail('식물 종');
    final String waterCycle = _getDetail('물 주기');
    final String fertilizerCycle = _getDetail('분갈이 주기');

    return SizedBox(
      height: 140, // Card 높이를 약간 늘림
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        color: const Color(0xFFF5F5F5),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // 모든 요소를 중앙 정렬
          children: [
            const SizedBox(width: 10), // 왼쪽 여백
            _postImage(),
            const SizedBox(width: 16), // 이미지와 텍스트 간격
            Expanded(
              child: _postContent(), // 텍스트 내용
            ),
            const SizedBox(width: 10), // 텍스트와 세로선 간격
            Container(
              width: 1,
              height: 100, // 세로선 고정 높이
              color: const Color(0xFF7D7D7D),
            ),
            const SizedBox(width: 10), // 세로선과 식물 정보 간격
            _plantInformation(plantSpecies, waterCycle, fertilizerCycle),
            const SizedBox(width: 10), // 오른쪽 여백
          ],
        ),
      ),
    );
  }
}
