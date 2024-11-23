// image_uploader.dart              # 이미지 업로드 컴포넌트
import 'package:flutter/material.dart';

class ImageUploader extends StatelessWidget {
  final String placeholderText;
  final VoidCallback onUpload;

  const ImageUploader({
    super.key,
    required this.placeholderText,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpload,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            placeholderText,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
