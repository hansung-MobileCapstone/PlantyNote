import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// 식물 전문가 서비스
/// .env 파일에 저장된 OPENAI_API_KEY를 사용하여, OpenAI Chat Completion API를 호출하고
/// 식물 관련 질문에 대한 답변을 받아옵니다.
class PlantExpertService {
  final String apiKey;

  // 생성자: dotenv에서 API 키를 읽어오며, 값이 없으면 예외를 발생시킵니다.
  PlantExpertService() : apiKey = dotenv.env['OPENAI_API_KEY'] ?? '' {
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY가 설정되어 있지 않습니다. .env 파일을 확인하세요.');
    }
  }

  /// sendMessage 함수는 사용자가 입력한 메시지를 받아 OpenAI의 Chat Completion API에 전달하고,
  /// 응답 문자열(식물 관련 답변)을 반환합니다.
  Future<String> sendMessage(String userMessage) async {
    final Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');

    // API 호출에 필요한 헤더 설정
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    // API 요청 본문 구성
    final Map<String, dynamic> bodyData = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content': '당신은 식물 전문가 PLANTY입니다. 식물 관련 질문에 대해 전문적이고 친절하게 답변하세요.'
        },
        {'role': 'user', 'content': userMessage},
      ],
      'temperature': 0.7,
      'max_tokens': 150,
    };

    final String body = jsonEncode(bodyData);

    try {
      final http.Response response =
          await http.post(url, headers: headers, body: body);

      // HTTP 응답이 성공(200) 상태가 아니면 예외 처리
      if (response.statusCode != 200) {
        throw Exception(
            'OpenAI API 호출 실패: ${response.statusCode} ${response.body}');
      }

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final String answer = jsonResponse['choices']?[0]?['message']?['content']
              ?.toString()
              .trim() ??
          '';

      if (answer.isEmpty) {
        throw Exception('OpenAI 응답 내용이 비어있습니다.');
      }
      return answer;
    } catch (e) {
      throw Exception('PlantExpertService 오류: ${e.toString()}');
    }
  }
}
