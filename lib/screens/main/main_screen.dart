import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../widgets/components/bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // 네비게이션바 인덱스

  void _onItemTapped(int index) { // 인덱스 상태관리
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar( // 상단바
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: _logoImage(),
          centerTitle: true, // 중앙 배치
          actions: [
            IconButton( // 푸시 알림 페이지
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(height: 5),
                _searchBar(), // 검색바
                SizedBox(height: 18),
                _mainContent(), // 중앙콘텐츠
                SizedBox(height: 50),
                _recentPosts(), // 최근게시물
              ]
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ), // 하단바
      ),
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
        Text('PlantyNote',
          style: TextStyle(
            fontSize: 23,
            color: Color(0xFF434343),
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  // 검색 바
  Widget _searchBar() {
    return Container(
      width: 380,
      height: 35,
      decoration: BoxDecoration(
        color: Color(0x264B7E5B), // 투명도15%
        borderRadius: BorderRadius.circular(15), // 15둥글게
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: '궁금한 식물을 검색해 보세요!',
          hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
          suffixIcon: Icon(Icons.search), // 오른쪽에 배치
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          border: InputBorder.none, // 테두리 제거
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
          padding: EdgeInsets.only(left: 40),
          child: Text(
            '누구나 몬스테라를\n쉽고 예쁘게\n키울 수 있도록.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 25),
        Center(
          child: ClipRRect( // boder-radius 주기 위함
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/main_plant.png', // 이미지 경로
              width: 220,
              height: 270,
              fit: BoxFit.fill, // 전체 채우기, cover도 가능
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
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Text(
                '최근 게시물',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(Icons.arrow_forward, size: 18), // 아이콘 추가
            ],
          ),
        ),
        SizedBox(height: 10),
        _makeCarousel(), // 캐러셀
      ],
    );
  }

  // 케러셀
  Widget _makeCarousel() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child : CarouselSlider(
          options: CarouselOptions(
            height: 190, // 높이 설정
            enlargeCenterPage: false, // 페이지 확대 안함
            enableInfiniteScroll: false, // 무한스크롤 안함
            autoPlay: false, // 자동슬라이드 안함
            initialPage: 1,
            viewportFraction: 0.4, // 각 게시물간 간격
          ),

          items: [ // 예시 게시물
            _postItem('팥이', '몬스테라', 'assets/images/sample_post.png'),
            _postItem('콩이', '레몬나무', 'assets/images/sample_post.png'),
            _postItem('그루트', '금전수', 'assets/images/sample_post.png'),
            _postItem('팥이', '몬스테라', 'assets/images/sample_post.png'),
            _postItem('콩이', '레몬나무', 'assets/images/sample_post.png'),
          ],
        ),
    );
  }

  // 각 게시물
  Widget _postItem(String name, String species, String imageUrl) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              width: 130,
              height: 130,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 5),
          Text(
            species,
            style: TextStyle(fontSize: 9, color: Color(0xFF757575)),
          ),
          Text(
            name,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

}
