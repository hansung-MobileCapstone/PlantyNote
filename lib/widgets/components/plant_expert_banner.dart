import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 메인 화면에 삽입할 식물 전문가 PLANTY 배너 위젯.
/// 이 위젯을 터치하면 대화 페이지('/conversation')로 이동합니다.
class PlantExpertBanner extends StatelessWidget {
  const PlantExpertBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 배너 터치 시 '/conversation' 라우트로 이동
        context.push('/conversation');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.chat_bubble_outline,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                '식물 전문가 PLANTY에게 물어보세요!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
