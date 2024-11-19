// my_plant_timeline_screen.dart    # 4-2번 화면
import 'package:flutter/material.dart';
import '../modals/notification_setting_modal.dart';
import '../modals/memo_create_modal.dart';
import '../modals/timeline_modal.dart';
import '../../widgets/components/memo_item.dart';

class MyPlantTimelineScreen extends StatefulWidget {
  const MyPlantTimelineScreen({super.key});

  @override
  State<MyPlantTimelineScreen> createState() => _MyPlantTimelineScreenState();
}

class _MyPlantTimelineScreenState extends State<MyPlantTimelineScreen> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팥이'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/my_plant_register');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // 삭제 로직 (삭제 처리 추가 필요)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _plantDetailsSection(),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                MemoItem(
                  date: '2024.10.06',
                  content: '꽃이 피었다!',
                  imageUrl: 'assets/images/sample_memo.png',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const TimelineModal(
                        memo: '꽃이 피었다!',
                        date: '2024.10.06',
                      ),
                    );
                  },
                ),
                MemoItem(
                  date: '2024.10.05',
                  content: '오늘 물을 주었다. 큰 꽃이 필 것 같아서 기대가 된다.',
                  imageUrl: 'assets/images/sample_memo.png',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const TimelineModal(
                        memo: '오늘 물을 주었다. 큰 꽃이 필 것 같아서 기대가 된다.',
                        date: '2024.10.05',
                      ),
                    );
                  },
                ),
                MemoItem(
                  date: '2024.10.01',
                  content: '팥이 키우기 시작.',
                  imageUrl: 'assets/images/sample_memo.png',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const TimelineModal(
                        memo: '팥이 키우기 시작.',
                        date: '2024.10.01',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const MemoCreateModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _plantDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIKE',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.wb_sunny_outlined),
              SizedBox(width: 4),
              Text('햇빛 적합'),
              Spacer(),
              Text('온도: 22°C'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'D-DAY',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _dDayBadge('D-1', Colors.blue),
              const SizedBox(width: 8),
              _dDayBadge('D-75', Colors.orange),
              const SizedBox(width: 8),
              _dDayBadge('D-300', Colors.purple),
            ],
          ),
          const SizedBox(height: 16),
          Row(
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
          ),
        ],
      ),
    );
  }

  Widget _dDayBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
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
}
