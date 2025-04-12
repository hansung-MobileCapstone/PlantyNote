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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.green[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['content'] ?? '',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식물 전문가 PLANTY와 대화'),
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
                      decoration: const InputDecoration(
                        hintText: '궁금한 사항을 입력하세요.',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _submitMessage(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _submitMessage,
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
