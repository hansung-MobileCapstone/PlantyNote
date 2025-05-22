import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/components/bottom_navigation_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1;
  String? selectedRecentSearch;
  final TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _addRecentSearch(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches.remove(keyword); // 중복 제거
    recentSearches.insert(0, keyword); // 앞으로 추가
    await prefs.setStringList('recent_searches', recentSearches);
    setState(() {});
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
    setState(() {
      recentSearches.clear();
    });
  }

  void _goToSearchResult(String keyword) {
    if (keyword.trim().isEmpty) return;
    _addRecentSearch(keyword.trim());
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("최근 검색어", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: const Text("전체 삭제", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _recentSearch(),
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
        height: 38,
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
                onSubmitted: (value) {
                  _goToSearchResult(value);
                },
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
    if (recentSearches.isEmpty) {
      return const Text("최근 검색어가 없습니다.", style: TextStyle(color: Colors.grey));
    }

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
}
