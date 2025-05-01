import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class LocationModal extends StatefulWidget {
  const LocationModal({super.key});

  @override
  LocationModalState createState() => LocationModalState();
}

class LocationModalState extends State<LocationModal> {
  bool _isLoading = false;
  final _locationController = TextEditingController();
  List<dynamic> _suggestions = [];
  String? _selectedAddress;

  // 구글맵 api key 불러오기
  String get _apiKey => Platform.isAndroid
      ? dotenv.env['ANDROID_MAPS_API_KEY']!
      : dotenv.env['IOS_MAPS_API_KEY']!;

  @override
  void initState() {
    super.initState();
    _locationController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _locationController.removeListener(_onSearchChanged);
    _locationController.dispose();
    super.dispose();
  }

  // 위치 검색 시 자동완성 검색
  void _onSearchChanged() {
    final input = _locationController.text.trim();
    if (input.isNotEmpty) {
      _fetchSuggestions(input);
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  // google places autocomplete api에서 결과 가져오기
  Future<void> _fetchSuggestions(String input) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$input&language=ko&components=country:kr&key=$_apiKey',
    );
    final response = await http.get(url);


    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _suggestions = json['predictions'];
      });
    }
  }

  // 사용자가 항목을 선택하면 상세 주소 가져오기
  Future<void> _selectPlace(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId&language=ko&key=$_apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final address = json['result']['formatted_address'];

      _locationController.removeListener(_onSearchChanged); // 재검색 트리거 방지
      setState(() {
        _selectedAddress = address;
        _locationController.text = address; // 설정위치 업데이트
        _suggestions = [];
      });
      _locationController.addListener(_onSearchChanged);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '위치 설정하기',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 20),
              _inputField(), // 검색 필드
              _suggestionList(), // 자동완성 리스트
              const SizedBox(height: 12),
              _settingLocation(), // 설정 위치
              const SizedBox(height: 25),
              _submitButton(), // 완료 버튼
            ],
          ),
        ),
      ),
    );
  }

  // 위치 검색 필드
  Widget _inputField() {
    return TextField(
      controller: _locationController,
      decoration: InputDecoration(
        hintText: '위치를 직접 설정해주세요!',
        hintStyle: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFB3B3B3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4B7E5B), width: 1),
        ),
      ),
      style: const TextStyle(fontSize: 13, color: Colors.black),
    );
  }

  // 자동완성 리스트(드롭다운)
  Widget _suggestionList() {
    print('[DEBUG] _suggestionList called with ${_suggestions.length} items');

    if (_suggestions.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFB3B3B3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.builder(
          itemCount: _suggestions.length,
          itemBuilder: (context, index) {
            final item = _suggestions[index];
            return ListTile(
              title: Text(item['description']),
              onTap: () => _selectPlace(item['place_id']), // 선택 처리
            );
          },
        ),
      ),
    );
  }

  // 설정 위치 출력
  Widget _settingLocation() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _selectedAddress != null
            ? '설정 위치: $_selectedAddress'
            : '설정 위치: -',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 완료 버튼
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_locationController.text.trim().isNotEmpty) {
          context.pop(_selectedAddress); // 설정한 위치를 MapCreateScreen으로 전송
        } else {
          Fluttertoast.showToast(
            msg: "위치를 설정해주세요.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: const Color(0xFFE81010),
            textColor: Colors.white,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4B7E5B),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: const Text('완료'),
    );
  }
}
