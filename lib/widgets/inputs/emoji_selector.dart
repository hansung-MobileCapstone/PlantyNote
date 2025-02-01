// emoji_selector.dart              # 이모티콘 선택 UI
import 'package:flutter/material.dart';

class EmojiSelector extends StatelessWidget {
  final List<String> emojis;
  final int selectedIndex;
  final ValueChanged<int> onEmojiSelected;

  const EmojiSelector({
    super.key,
    required this.emojis,
    required this.selectedIndex,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        emojis.length,
            (index) => GestureDetector(
          onTap: () => onEmojiSelected(index),
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedIndex == index ? Color(0xFF4B7E5B) : Colors.transparent, // 선택된 테두리
                width: 2,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              emojis[index],
              style: TextStyle(
                fontSize: 20, // 이모지 크기
              ),
            ),
          ),
        ),
      ),
    );
  }
}
