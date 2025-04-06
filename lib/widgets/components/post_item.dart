import 'package:flutter/material.dart';

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

  String _getDetail(String key) {
    for (var detail in details) {
      if (detail.containsKey(key)) {
        return detail[key] ?? '정보 없음';
      }
    }
    return '정보 없음';
  }

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
                child: Image.network(
                  imageUrls[1],
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrls.isNotEmpty
                ? Image.network(
              imageUrls[0],
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            )
                : Image.network(
              'https://res.cloudinary.com/heyset/image/upload/v1689582418/buukmenow-folder/no-image-icon-0.jpg',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _postContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(profileImage),
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
            style: const TextStyle(fontSize: 7, color: Color(0xFF7D7D7D)),
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
}
