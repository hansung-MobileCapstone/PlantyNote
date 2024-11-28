import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modals/notification_setting_modal.dart';
import '../modals/memo_create_modal.dart';
import '../modals/timeline_modal.dart';
import '../../widgets/components/memo_item.dart';

class MyPlantTimelineScreen extends StatefulWidget {
  MyPlantTimelineScreen({super.key});

  @override
  State<MyPlantTimelineScreen> createState() => _MyPlantTimelineScreenState();
}

class _MyPlantTimelineScreenState extends State<MyPlantTimelineScreen> {
  bool isNotificationEnabled = false;

  // Memo 예시 데이터
  final List<Map<String, dynamic>> memos = [
    {
      'date': '2024.10.06',
      'content': '꽃이 피었다!',
      'imageUrl': 'assets/images/sample_post.png',
    },
    {
      'date': '2024.10.05',
      'content': '오늘 물을 주었다. 큰 꽃이 필 것 같아서 기대가 된다.',
      'imageUrl': '',
    },
    {
      'date': '2024.10.01',
      'content': '팥이 키우기 시작.',
      'imageUrl': 'assets/images/sample_post.png',
    },
    {
      'date': '2024.10.01',
      'content': '팥이 키우기 시작.',
      'imageUrl': '',
    },
    {
      'date': '2024.10.01',
      'content': '팥이 키우기 시작.',
      'imageUrl': 'assets/images/sample_post.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar( // 식물 이미지
              radius: 75,
            ),
            SizedBox(height: 15),
            _dDayWithBadge(), // 함께한지 뱃지
            _plantDetailsSection(), // 식물 정보
            Divider(
              color: Color(0xFF7D7D7D),
              thickness: 0.7,
              indent: 18,
              endIndent: 18,
            ),
            SizedBox(height: 15),
            Text(
              '타임라인',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // 타임라인 리스트
            ListView(
              padding: const EdgeInsets.all(16),
              physics: NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
              shrinkWrap: true,
              children: memos.take(3).map((memo) { // 최근 3개의 Memo만 보이기
                return MemoItem(
                  //date: memo['date'],
                  //content: memo['content'],
                  //imageUrl: memo['imageUrl'],
                );
              }).toList(),
            ),
            InkWell( // 더보기 버튼
              onTap: () {
                _showTimeLineModal(context);
              },
              child: Text(
                '더보기',
                style: TextStyle(
                  color: Color(0xFF4B7E5B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const MemoCreateModal(),
          );
        },
        backgroundColor: Colors.white, // 배경색 변경
        elevation: 4, // 그림자 높이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // 모서리 반경 조정
        ),
        child: Icon(
          Icons.add_circle,
          color: Color(0xFF4B7E5B),
          size: 40,
      ),
      ),
    );
  }

  // 상단 바
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      title: Text(
        '팥이',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton( // 수정 버튼
          icon: Icon(Icons.edit, color: const Color(0xFF7D7D7D), size: 24),
          onPressed: () {
            context.push('/plants/register'); // 내식물등록페이지로 이동
            // 게시물작성페이지에 현재 데이터 전달 필요 (extra)
          },
        ),
        IconButton( // 삭제 버튼
          icon: Icon(Icons.delete, color: const Color(0xFFDA2525), size: 24),
          onPressed: () {
            _showDeleteDialog(context); // 삭제 팝업 표시
          },
        ),
      ],
    );
  }

  // 삭제 확인 팝업
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("내 식물 삭제"),
          content: Text("정말 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
              },
              child: Text("아니오"),
            ),
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
                context.go('/plants'); // 내식물모음페이지로 이동
                // 삭제 기능 구현
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }

  // 함께한지 D+Day 뱃지
  Widget _dDayWithBadge() {
    return IntrinsicWidth (
      child: Container(
        padding: const EdgeInsets.symmetric(vertical:4, horizontal:30),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE7B4BA), width: 1.5), // 테두리 색상
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          "♥ 팥이와 함께한지 220일 ♥",
          style: TextStyle(
            color: Color(0xFFE7B4BA),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // 식물 정보
  Widget _plantDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIKE',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF697386)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            _plantLike(),
          ),
          const SizedBox(height: 16),
          const Text(
            'D-DAY',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF697386)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            _plantDday(),
          ),
          const SizedBox(height: 16),
          _toggleButton(),
        ],
      ),
    );
  }

  // LIKE 부분
  Widget _plantLike() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 첫 번째 Row (햇빛)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('햇빛', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Text('적음', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                for (int i = 0; i < 5; i++)
                  Icon(Icons.wb_sunny, color: Color(0xFFFDD941)),
                SizedBox(width: 8),
                Text('많음', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        // 두 번째 Row (물)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('물', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Text('적음', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                for (int i = 0; i < 5; i++)
                  Icon(Icons.water_drop, color: Color(0xFF8FD7FF)),
                SizedBox(width: 8),
                Text('많음', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        // 세 번째 Row (온도)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('온도', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Text('-10', style: TextStyle(fontSize: 14)),
                SliderTheme(
                  data: SliderThemeData(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  ),
                  child: Slider(
                    value: 20.0,
                    min: -10,
                    max: 40,
                    onChanged: (value) {},
                    activeColor: Colors.orange,
                    inactiveColor: Colors.grey,
                  ),
                ),
                Text('40', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // D-DAY 부분
  Widget _plantDday() {
    return Row(
      children: [
        _dDayBadge('D-1', Color(0xFF95CED5)),
        const SizedBox(width: 8),
        _dDayBadge('D-75', Color(0xFFEAC7A8)),
        const SizedBox(width: 8),
        _dDayBadge('D-300', Color(0xFFCABECE)),
      ],
    );
  }

  Widget _dDayBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 물주기 알림 토글 버튼, 시간 설정
  Widget _toggleButton() {
    return Row(
      children: [
        const Text('물 주기 알림', style: TextStyle(fontSize: 16)),
        const Spacer(),
        Switch(
          value: isNotificationEnabled,
          onChanged: (value) {
            setState(() {
              isNotificationEnabled = value;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.timer),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const NotificationSettingModal(),
            );
          },
        ),
      ],
    );
  }

  // 댓글 모달 표시
  void _showTimeLineModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 모달의 크기 조정을 위해
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85, // 화면 높이의 85%로 설정
          child: TimelineModal(), // comment_modal.dart에 정의된 위젯
        );
      },
    );
  }

}
