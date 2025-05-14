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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Color(0xFFC9DDD0),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Color(0xFF4B7E5B), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.smart_toy_outlined,
              color: Color(0xFF4B7E5B),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                '식물 전문가 PLANTY에게 물어보세요!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B7E5B),
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
