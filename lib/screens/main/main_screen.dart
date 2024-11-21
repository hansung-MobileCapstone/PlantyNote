import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import '../community/all_posts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // 네비게이션바 인덱스

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 인덱스 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              _searchBar(),
              SizedBox(height: 18),
              _mainContent(),
              SizedBox(height: 50),
              _recentPosts(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // 상단바
  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: _logoImage(),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // 푸시 알림 페이지로 이동
          },
        ),
      ],
    );
  }


  // 상단 로고 위젯
  Widget _logoImage() {
    return Row(
      mainAxisSize: MainAxisSize.min, // 크기를 내용에 맞춤
      crossAxisAlignment: CrossAxisAlignment.center, // 가로축 정렬
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 32, // 로고 크기를 조정
        ),
        SizedBox(width: 7), // 로고와 텍스트 간격
        Text(
          'PlantyNote',
          style: TextStyle(
            fontSize: 23,
            color: const Color(0xFF434343),
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  // 검색 바
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // 화면 끝과 일정한 간격 유지
      child: Container(
        height: 35, // 고정된 높이
        decoration: BoxDecoration(
          color: const Color(0x264B7E5B), // 투명도 15%
          borderRadius: BorderRadius.circular(15), // 둥근 모서리
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: '궁금한 식물을 검색해 보세요!',
            hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
            suffixIcon: const Icon(Icons.search), // 오른쪽에 배치
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: InputBorder.none, // 테두리 제거
          ),
        ),
      ),
    );
  }

  // 메인 컨텐츠 (광고멘트, 이미지)
  Widget _mainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40),
          child: const Text(
            '누구나 몬스테라를\n쉽고 예쁘게\n키울 수 있도록.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: ClipRRect( // border-radius 주기 위함
            borderRadius: BorderRadius.circular(10), // 둥근 모서리
            child: Image.asset(
              'assets/images/main_plant.png', // 이미지 경로
              width: MediaQuery.of(context).size.width * 0.6, // 화면 너비의 60%
              height: (MediaQuery.of(context).size.width * 0.6) * (270 / 220), // 고정 비율
              fit: BoxFit.fill, // 전체 채우기
            ),
          ),
        ),

      ],
    );
  }

  // 최근 게시물
  Widget _recentPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Text(
                '최근 게시물',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 18),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllPostsScreen(), // 전체게시물 페이지로 이동
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 15), // 간격을 화면 크기에 상관없이 고정
        _makeCarousel(), // 캐러셀
      ],
    );
  }

  // 각 게시물
  Widget _postItem(String name, String species, String imageUrl) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxItemWidth = 160; // 최대 아이템 너비 제한
    final double itemWidth = (screenWidth * 0.3).clamp(100, maxItemWidth);
    final double itemHeight = itemWidth * (120 / 130); // 고정 비율

    return Container(
      width: itemWidth,
      margin: const EdgeInsets.symmetric(horizontal: 9), // 간격 고정
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // 둥근 모서리
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // 둥근 모서리
            child: Image.asset(
              imageUrl,
              width: itemWidth,
              height: itemHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8), // 간격 고정
          // 종 텍스트
          Text(
            species,
            style: const TextStyle(fontSize: 12, color: Colors.grey), // 텍스트 스타일
          ),
          // 이름 텍스트
          Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 텍스트 스타일
          ),
        ],
      ),
    );
  }

// 캐러셀
  Widget _makeCarousel() {
    const double itemSpacing = 16; // 게시물 간 간격
    const double maxViewportFraction = 0.4; // 최대 viewportFraction 제한
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = (screenWidth * 0.3).clamp(100, 160);
    final double viewportFraction = (itemWidth + itemSpacing) / screenWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // 캐러셀 전체 패딩
      child: CarouselSlider.builder(
        itemCount: 6, // 게시물 수
        itemBuilder: (context, index, realIndex) {
          final items = [ // 예시 데이터
            {'name': '팥이', 'species': '몬스테라', 'imageUrl': 'assets/images/sample_post.png'},
            {'name': '콩이', 'species': '레몬나무', 'imageUrl': 'assets/images/sample_post.png'},
            {'name': '그루트', 'species': '금전수', 'imageUrl': 'assets/images/sample_post.png'},
            {'name': '팥이', 'species': '몬스테라', 'imageUrl': 'assets/images/sample_post.png'},
            {'name': '콩이', 'species': '레몬나무', 'imageUrl': 'assets/images/sample_post.png'},
            {'name': '그루트', 'species': '금전수', 'imageUrl': 'assets/images/sample_post.png'},
          ];
          final item = items[index];
          return _postItem(item['name']!, item['species']!, item['imageUrl']!);
        },
        options: CarouselOptions(
          height: 200, // 캐러셀 높이
          viewportFraction: viewportFraction.clamp(0.2, maxViewportFraction),
          enableInfiniteScroll: false, // 무한 스크롤 비활성화
          autoPlay: false, // 자동 스크롤 비활성화
          enlargeCenterPage: false, // 가운데 아이템 확대 비활성화
          initialPage: 2,
        ),
      ),
    );
  }



}
