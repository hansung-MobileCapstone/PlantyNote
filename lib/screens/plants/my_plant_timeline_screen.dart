import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../modals/memo_create_modal.dart';
import '../modals/timeline_modal.dart';
import '../../widgets/components/memo_item.dart';
import 'dart:io';
import '../../util/calculateDday.dart';

class MyPlantTimelineScreen extends StatefulWidget {
  final String plantId;

  MyPlantTimelineScreen({super.key, required this.plantId});

  @override
  State<MyPlantTimelineScreen> createState() => _MyPlantTimelineScreenState();
}

class _MyPlantTimelineScreenState extends State<MyPlantTimelineScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> plantDataFuture;
  bool isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    plantDataFuture = _fetchPlantData();

    _loadNotificationStatus(); // 알림 토글값 불러오는 함수
  }

  void _loadNotificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plants')
        .doc(widget.plantId)
        .get();

    if (doc.exists) {
      setState(() {
        isNotificationEnabled = doc.data()?['isNotificationEnabled'] ?? false;
      });
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchPlantData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("로그인된 사용자가 없습니다.");
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // 로그인된 사용자의 UID
        .collection('plants')
        .doc(widget.plantId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: plantDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('데이터를 불러올 수 없습니다.'));
          }

          final plantData = snapshot.data!.data()!;
          final plantName = plantData['plantname'] ?? '식물 이름 없음';
          final imageUrl = plantData['imageUrl'] ?? '';
          final meetingDate = DateTime.parse(plantData['meetingDate']);
          final sunlightLevel = plantData['sunlightLevel'] ?? 0;
          final waterLevel = plantData['waterLevel'] ?? 0;
          final temperature = plantData['temperature'] ?? 0.0;
          final waterDate = DateTime.parse(plantData['waterDate']) ?? DateTime.now();
          final waterCycle = plantData['waterCycle'] ?? 0;
          final fertilizerCycle = plantData['fertilizerCycle'] ?? 0;
          final repottingCycle = plantData['repottingCycle'] ?? 0;

          final file = File(imageUrl);

          // 함께한 D-Day 계산
          final dDayTogether = calculateLife(meetingDate);

          return SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundImage: imageUrl.isNotEmpty
                      ? FileImage(file)
                      : const AssetImage('assets/images/default_post.png')
                  as ImageProvider,
                ),
                const SizedBox(height: 15),
                _dDayWithBadge(plantName, dDayTogether),
                const SizedBox(height: 15),
                _plantDetailsSection(
                  sunlightLevel: sunlightLevel,
                  waterLevel: waterLevel,
                  temperature: temperature,
                  dDayWater: calculateWater(waterDate, waterCycle * 1.0),
                  dDayFertilizer: calculateWater(meetingDate, fertilizerCycle * 30.0),
                  dDayRepotting: calculateWater(meetingDate, repottingCycle * 30.0),
                ),
                const Divider(
                  color: Color(0xFF7D7D7D),
                  thickness: 0.7,
                  indent: 18,
                  endIndent: 18,
                ),
                const SizedBox(height: 15),
                Text(
                  '타임라인',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildRecentMemos(), // 최신 메모 3개만 보이기
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => MemoCreateModal(plantId: widget.plantId),
          );
        },
        backgroundColor: Colors.white, // 배경색 변경
        elevation: 4, // 그림자 높이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
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
      title: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: plantDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
              '...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text(
              '식물 이름 없음',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          }

          final plantData = snapshot.data!.data()!;
          final plantName = plantData['plantname'] ?? '식물 이름 없음';

          return Text(
            plantName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      centerTitle: true,
      actions: [
        IconButton( // 수정 버튼
          icon: const Icon(
              Icons.edit_outlined, color: Color(0xFF7D7D7D), size: 24),
          onPressed: () async {
            final snapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('plants')
                .doc(widget.plantId)
                .get();

            if (snapshot.exists) {
              final plantData = snapshot.data();
              context.push(
                '/plants/register', // 내식물등록페이지로 이동
                extra: {
                  'isEditing': true,
                  'plantId': widget.plantId,
                  'plantData': plantData,
                },
              );
            }
          },
        ),
        IconButton( // 삭제 버튼
          icon: const Icon(
              Icons.delete_outlined, color: Color(0xFFDA2525), size: 24),
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
                _deletePlant(context);
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }

  // firebase에서 삭제
  Future<void> _deletePlant(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("로그인된 사용자가 없습니다.");
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants')
          .doc(widget.plantId)
          .delete();

      // 삭제 성공 메시지
      Fluttertoast.showToast(
        msg: "식물 삭제 완료",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color(0xFF4B7E5B),
        textColor: Colors.white,
        fontSize: 13.0,
      );

      // 식물 모음 페이지로 이동
      context.go('/plants');
    } catch (e) {
      // 삭제 실패 메시지 표시
      Fluttertoast.showToast(
        msg: "삭제 실패..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFE81010),
        textColor: Colors.white,
        fontSize: 13.0,
      );
    }
  }

  // 함께한지 D+Day 뱃지
  Widget _dDayWithBadge(String plantName, int dDayTogether) {
    return IntrinsicWidth (
      child: Container(
        padding: const EdgeInsets.symmetric(vertical:4, horizontal:30),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE7B4BA), width: 1.5), // 테두리 색상
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          "♥ $plantName와 함께한지 $dDayTogether일 ♥",
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
  Widget _plantDetailsSection({
    required int sunlightLevel,
    required int waterLevel,
    required double temperature,
    required int dDayWater,
    required int dDayFertilizer,
    required int dDayRepotting
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'LIKE',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF697386)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.fromLTRB(40,20,40,10),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            _plantLike(sunlightLevel, waterLevel, temperature),
          ),
          const SizedBox(height: 16),
          const Text(
            'D-DAY',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF697386)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            _plantDday(dDayWater, dDayFertilizer, dDayRepotting),
          ),
          const SizedBox(height: 16),
          _toggleButton(),
        ],
      ),
    );
  }

  // LIKE 부분
  Widget _plantLike(int sunlightLevel, int waterLevel, double temperature) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 첫 번째 Row (햇빛)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('햇빛', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF697386))),
            Row(
              children: [
                Text('적음', style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3))),
                SizedBox(width: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(
                        Icons.wb_sunny,
                        color: index < sunlightLevel ? Color(0xFFFDD941) : Color(0x4DFDD941),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text('많음', style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3))),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        // 두 번째 Row (물)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('물', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF697386))),
            Row(
              children: [
                Text('적음', style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3))),
                SizedBox(width: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(
                        Icons.water_drop,
                        color: index < waterLevel ? Color(0xFF8FD7FF) : Color(0x4D8FD7FF),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text('많음', style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3))),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        // 세 번째 Row (온도)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('온도', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF697386))),
            Row(
              children: [
                Text('-10', style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3))),
                SizedBox(
                  width: 205, // 슬라이더 크기
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFFE6E6E6),
                      inactiveTrackColor: const Color(0xFFE6E6E6),
                      thumbColor: const Color(0xFF4B7E5B),
                      trackHeight: 3.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6.0,
                      ),
                      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: const Color(0xFF4B7E5B),
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: temperature, // my_plant_register에서 선택한 온도
                      min: -10,
                      max: 40,
                      divisions: 50,
                      label: '${temperature}°C',
                      onChanged: (value) {}, // 고정
                    ),
                  ),
                ),
                Text('40', style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3))),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // D-DAY 부분
  Widget _plantDday(int dDayWater, int dDayFertilizer, int dDayRepotting) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('물', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF697386))),
        const SizedBox(width: 10),
        _dDayBadge('D-$dDayWater', Color(0xFF95CED5)),
        const SizedBox(width: 20),
        Text('영양제', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF697386))),
        const SizedBox(width: 10),
        _dDayBadge('D-$dDayFertilizer', Color(0xFFEAC7A8)),
        const SizedBox(width: 20),
        Text('분갈이', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF697386))),
        const SizedBox(width: 10),
        _dDayBadge('D-$dDayRepotting', Color(0xFFCABECE)),
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
        const Text('  물 주기 알림',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF697386)),
        ),
        const Spacer(),
        const SizedBox(width: 10),
        Switch(
          value: isNotificationEnabled,
          onChanged: (value) async {
            setState(() {
              isNotificationEnabled = value;
            });

            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('plants')
                .doc(widget.plantId)
                .update({'isNotificationEnabled': value});
            }
          },
          activeColor: Color(0xFFFFFFFF), // 활성 상태의 thumb 색상
          activeTrackColor: Color(0xFF4B7E5B), // 활성 상태의 track 색상
          inactiveThumbColor: Color(0xFFFFFFFF), // 비활성 상태의 thumb 색상
          inactiveTrackColor: Color(0xFFB3B3B3), // 비활성 상태의 track 색상
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
          child: TimelineModal(plantId: widget.plantId,), // comment_modal.dart에 정의된 위젯
        );
      },
    );
  }

  // 최신 메모 3개 표시
  Widget _buildRecentMemos() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('로그인된 사용자가 없습니다.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants')
          .doc(widget.plantId)
          .collection('memos')
          .orderBy('createdAt', descending: true)
          .limit(3)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text(
              '메모를 작성해 보세요!',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 15,
              ),
          ));
        }

        final memos = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: memos.length,
          itemBuilder: (context, index) {
            final memo = memos[index];
            final data = memo.data() as Map<String, dynamic>;
            final memoId = memo.id;

            return MemoItem(
              date: (data['createdAt'] as Timestamp?)?.toDate().toString().substring(0, 10) ?? '-',
              content: data['content'] ?? '내용 없음',
              imageUrl: data['imageUrl'] ?? '',
              emojiIndex: data['emoji'] ?? 0,
              memoId: memoId,
              plantId: widget.plantId,
            );
          },
        );
      },
    );
  }

}
