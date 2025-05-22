import 'package:flutter/material.dart';
import 'package:plant/services/plant_expert_service.dart';

/// 식물 전문가 PLANTY와의 대화를 위한 페이지.
/// 사용자가 입력한 질문에 대해 PlantExpertService를 호출해 응답을 받아오며,
/// 대화 내역을 화면에 순차적으로 표시합니다.
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final PlantExpertService _plantExpertService = PlantExpertService();
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _conversations = [];
  bool _isLoading = false;

  /// 사용자의 입력 메시지를 전송하고, 응답을 받아 대화 내역에 추가합니다.
  Future<void> _submitMessage() async {
    final String inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    // 사용자의 메시지를 대화 목록에 추가하고 입력창 초기화
    setState(() {
      _conversations.add({'role': 'user', 'content': inputText});
      _isLoading = true;
    });
    _textController.clear();

    try {
      final String answer = await _plantExpertService.sendMessage(inputText);
      setState(() {
        _conversations.add({'role': 'assistant', 'content': answer});
      });
    } catch (error) {
      setState(() {
        _conversations.add({
          'role': 'assistant',
          'content': '오류가 발생했습니다: ${error.toString()}'
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 단일 대화 메시지 위젯.
  /// 사용자가 보낸 메시지와 PLANTY의 응답을 구분하여 좌우 정렬합니다.
  Widget _buildMessageWidget(Map<String, String> message) {
    final bool isUserMessage = message['role'] == 'user';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.white : Color(0xFFE4ECE6),
          borderRadius: BorderRadius.circular(20),
          border: isUserMessage
              ? Border.all(color: Color(0xFFC9DDD0), width: 1.5)
              : null, // user인 경우만 빨간 border
        ),
        child: Text(
          message['content'] ?? '',
          style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '식물 전문가 PLANTY',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 대화 내역 표시 영역
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  return _buildMessageWidget(_conversations[index]);
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            // 메시지 입력창 및 전송 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'PLANTY에게 궁금한 점을 물어보세요!',
                        hintStyle: const TextStyle(color: Color(0xFF757575)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(color: Color(0xFFB3B3B3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(color: Color(0xFFB3B3B3)),
                        ),
                      ),
                      onSubmitted: (_) => _submitMessage(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    height: 40,

                    decoration: BoxDecoration(
                      color: const Color(0xFF4B7E5B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: _submitMessage,
                      child: const Text(
                        '입력',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
