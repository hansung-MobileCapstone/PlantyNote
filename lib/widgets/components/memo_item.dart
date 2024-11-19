// memo_item.dart                   # 메모 아이템 UI
import 'package:flutter/material.dart';

class MemoItem extends StatelessWidget {
  final String date;
  final String content;
  final String imageUrl;
  final VoidCallback onTap;

  const MemoItem({
    super.key,
    required this.date,
    required this.content,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
          ),
          title: Text(date),
          subtitle: Text(
            content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
