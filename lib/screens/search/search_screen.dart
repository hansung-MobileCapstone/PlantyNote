// ✅ search_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1;
  int selectedTab = 0;
  String? selectedRecentSearch;
  final TextEditingController _searchController = TextEditingController();

  final List<String> recentSearches = ["고목나무", "알라비", "레몬 나무"];
  final List<String> popularSearches = [
    "고목나무",
    "쉐프렐라",
    "레몬 나무",
    "홍콩 야자",
    "유칼립투스"
  ];
  final List<String> tabs = ["실시간", "일간", "주간", "월간"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToSearchResult(String keyword) {
    if (keyword.trim().isEmpty) return;
    context.push('/main/search/result', extra: {'keyword': keyword.trim()});
  }

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
            const SizedBox(height: 10),
            _searchBar(),
            const SizedBox(height: 20),
            const Text("최근 검색어", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _recentSearch(),
            const SizedBox(height: 20),
            const Text("인기 검색어", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _popularSearchTap(),
            const SizedBox(height: 20),
            _popularSearch(),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        '게시물 검색',
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0x264B7E5B),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: '궁금한 식물을 검색해 보세요!',
                  hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _goToSearchResult(_searchController.text);
              },
              child: const Icon(Icons.search, color: Color(0xFFB3B3B3)),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _recentSearch() {
    return Wrap(
      spacing: 8,
      children: recentSearches.map((search) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedRecentSearch = search;
            });
            _goToSearchResult(search);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selectedRecentSearch == search ? Colors.grey[300] : Colors.white,
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(search, style: const TextStyle(fontSize: 14, color: Colors.black)),
          ),
        );
      }).toList(),
    );
  }

  Widget _popularSearchTap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: tabs.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTab = entry.key;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selectedTab == entry.key ? Colors.green[800] : Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              entry.value,
              style: TextStyle(color: selectedTab == entry.key ? Colors.white : Colors.black),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _popularSearch() {
    return Expanded(
      child: ListView.builder(
        itemCount: popularSearches.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text("${index + 1}. ${popularSearches[index]}", style: const TextStyle(fontSize: 16)),
          );
        },
      ),
    );
  }
}
