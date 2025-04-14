import 'package:flutter/material.dart';
import 'dart:io';

// 게시물 하나를 나타내는 위젯
class PostItem extends StatelessWidget {
  final String name;
  final String profileImage;
  final String contents;
  final List<String> imageUrls;
  final List<Map<String, dynamic>> details;
  final String? keyword;

  const PostItem({
    super.key,
    required this.name,
    required this.profileImage,
    required this.contents,
    required this.imageUrls,
    required this.details,
    this.keyword,
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

  // 키워드가 있을 경우 해당 텍스트 일부를 하이라이트하는 헬퍼 함수
  TextSpan _highlight(String text, {TextStyle? style}) {
    if (keyword == null || keyword!.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword!.toLowerCase();

    if (!lowerText.contains(lowerKeyword)) {
      return TextSpan(text: text, style: style);
    }

    final spans = <TextSpan>[];
    int start = 0;
    int index;

    while ((index = lowerText.indexOf(lowerKeyword, start)) != -1) {
      if (start < index) {
        spans.add(TextSpan(text: text.substring(start, index), style: style));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + keyword!.length),
        style: style?.copyWith(
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.yellow.withOpacity(0.5),
        ),
      ));
      start = index + keyword!.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }

    return TextSpan(children: spans);
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

  // 게시글 내용을 표시하는 위젯 (RichText로 하이라이트 적용)
  Widget _postContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundImage: profileImage.startsWith('http')
                  ? NetworkImage(profileImage)
                  : AssetImage(profileImage) as ImageProvider,
            ),
            const SizedBox(width: 8),
            RichText(
              text: _highlight(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RichText(
          text: _highlight(
            contents,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF7D7D7D),
            ),
          ),
        ),
      ],
    );
  }

  // 식물 정보를 표시하는 위젯
  Widget _plantInformation(String plantSpecies, String waterCycle, String fertilizerCycle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _informationRow('식물 종', plantSpecies),
        const SizedBox(height: 8),
        _informationRow('물 주기', waterCycle),
        const SizedBox(height: 8),
        _informationRow('분갈이 주기', fertilizerCycle),
      ],
    );
  }

  // 개별 정보 행을 표시하는 위젯 (하이라이트 적용)
  Widget _informationRow(String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0x804B7E5B)),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 7, color: Color(0xFF7D7D7B)),
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: _highlight(
            value,
            style: const TextStyle(
              fontSize: 7,
              color: Color(0xFF616161),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String plantSpecies = _getDetail('식물 종');
    final String waterCycle = _getDetail('물 주기');
    final String fertilizerCycle = _getDetail('분갈이 주기');

    return SizedBox(
      height: 140,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        color: const Color(0xFFF5F5F5),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            _postImage(),
            const SizedBox(width: 16),
            Expanded(child: _postContent()),
            const SizedBox(width: 10),
            Container(width: 1, height: 100, color: const Color(0xFF7D7D7D)),
            const SizedBox(width: 10),
            _plantInformation(plantSpecies, waterCycle, fertilizerCycle),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
