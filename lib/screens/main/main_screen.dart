import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
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
          child: Center (
            child: Column(
                children: [
                  _searchBar(),
                  SizedBox(height: 18),
                  _mainContent()
                ]
            ),
          ),

        ),
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
      width: 360,
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
}
