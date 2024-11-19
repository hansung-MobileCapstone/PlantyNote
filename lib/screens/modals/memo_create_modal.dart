// memo_create_modal.dart           # 4-2-2번 화면
import 'package:flutter/material.dart';
import '../../widgets/inputs/emoji_selector.dart';
import '../../widgets/inputs/image_uploader.dart';

class MemoCreateModal extends StatefulWidget {
  const MemoCreateModal({super.key});

  @override
  State<MemoCreateModal> createState() => _MemoCreateModalState();
}

class _MemoCreateModalState extends State<MemoCreateModal> {
  final _memoController = TextEditingController();
  int selectedEmojiIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmojiSelector(
              emojis: ['😀', '😐', '😢'],
              selectedIndex: selectedEmojiIndex,
              onEmojiSelected: (index) {
                setState(() {
                  selectedEmojiIndex = index;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _memoController,
              decoration: const InputDecoration(labelText: '오늘의 한줄 메모'),
            ),
            const SizedBox(height: 16),
            ImageUploader(
              placeholderText: '이미지 추가 (10MB 이하)',
              onUpload: () {
                // 업로드 로직
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_memoController.text.trim().isNotEmpty) {
                  Navigator.pop(context, _memoController.text.trim());
                }
              },
              child: const Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
