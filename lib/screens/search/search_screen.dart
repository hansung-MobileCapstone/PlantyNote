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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10), // 화면 상단 여백
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 버튼
                  onPressed: () {
                    Navigator.pop(context); // 이전 화면으로 이동
                  },
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20), // 검색창 둥글게
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '검색어를 입력하세요',
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.black54), // 오른쪽 끝에 배치
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "최근 검색어",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: recentSearches
                  .map(
                    (search) => GestureDetector(
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
            ),
            SizedBox(height: 20),
            Text(
              "인기 검색어",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: tabs
                  .asMap()
                  .entries
                  .map(
                    (entry) => GestureDetector(
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
                            : Colors.black, // 터치 전 검정색 텍스트
                      ),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
            SizedBox(height: 20),
            Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}
