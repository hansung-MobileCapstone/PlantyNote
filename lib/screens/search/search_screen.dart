import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int selectedTab = 0; // 실시간, 일간, 주간, 월간 탭 상태
  String? selectedRecentSearch; // 선택된 최근 검색어
  final List<String> recentSearches = ["고목나무", "알라비", "레몬 나무"];
  final List<String> popularSearches = [
    "고목나무",
    "쉐프렐라",
    "레몬 나무",
    "홍콩 야자",
    "유칼립투스"
  ];
  final List<String> tabs = ["실시간", "일간", "주간", "월간"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10), // 화면 상단 여백
            _searchBar(), // 검색 바
            SizedBox(height: 20),
            Text(
              "최근 검색어",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _recentSearch(), // 최근 검색어 목록
            SizedBox(height: 20),
            Text(
              "인기 검색어",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _popularSearchTap(), // 인기 검색어 탭
            SizedBox(height: 20),
            _popularSearch(), // 인기 검색어 목록
          ],
        ),
      ),
    );
  }

  // 상단 바
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        '게시물 검색',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  // 검색 바
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0x264B7E5B), // 배경색
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SizedBox(width: 16), // 좌측 패딩
            Icon(Icons.search, color: Color(0xFFB3B3B3)),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '궁금한 식물을 검색해 보세요!',
                  hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
                  border: InputBorder.none,
                  //contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  // 검색 입력값 처리
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  // 최근 검색어 목록
  Widget _recentSearch() {
    return Wrap(
      spacing: 8,
      children: recentSearches
          .map(
            (search) =>
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedRecentSearch = search;
                });
              },
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedRecentSearch == search
                      ? Colors.grey[300] // 선택 시 회색
                      : Colors.white, // 기본 흰색
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  search,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
      )
          .toList(),
    );
  }

  // 인기 검색어 탭 (실시간, 일간, 주간, 월간)
  Widget _popularSearchTap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: tabs
          .asMap()
          .entries
          .map(
            (entry) =>
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = entry.key;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedTab == entry.key
                      ? Colors.green[800] // 터치 시 초록색
                      : Colors.white, // 기본은 흰색
                  border: Border.all(
                    color: Colors.grey[300]!, // 테두리 색상
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: selectedTab == entry.key
                        ? Colors.white
                        : Colors.black, // 터치 전 검정색
                  ),
                ),
              ),
            ),
      )
          .toList(),
    );
  }

  // 인기 검색어 목록
  Widget _popularSearch() {
    return Expanded(
      child: ListView.builder(
        itemCount: popularSearches.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "${index + 1}. ${popularSearches[index]}",
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }

}