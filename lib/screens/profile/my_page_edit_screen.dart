import 'package:flutter/material.dart';
import 'my_page_edit_screen.dart';
import 'package:plant/widgets/components/bottom_navigation_bar.dart';

class MyPageEditScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageEditScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final int plantCount = 2;

  // 이미지 경로 리스트
  final List<String> imagePaths = [
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png'
    // 추가 이미지 경로
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
         automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
        iconTheme: IconThemeData(color: Colors.black),
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20.0),
          child: Text(
            'MY 프로필 수정',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 16.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'PW변경',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      // Body 설정
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, right: 25.0, left: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // 프로필 정보
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/profile_image.png'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 이름 텍스트를 감싸는 흰 박스
                            Container(
                              height: 30,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.1),
                              decoration: BoxDecoration(
                                color: Colors.white, // 흰색 배경
                                borderRadius: BorderRadius.circular(8), // 둥근 모서리

                              ),
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = '마이클', // 기본 텍스트
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800], // 기존 텍스트 색상
                                ),
                                decoration: InputDecoration(
                                  hintText: '이름 입력', // 힌트 텍스트
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            // 자기소개 텍스트를 감싸는 흰 박스
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.white, // 흰색 배경
                                borderRadius: BorderRadius.circular(8), // 둥근 모서리
                              ),
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = '안녕하세요, 초보 식집사입니다.', // 기본 텍스트
                                style: TextStyle(
                                  fontSize: 12, // 기존 텍스트 크기
                                  color: Colors.green[800], // 기존 텍스트 색상
                                ),
                                decoration: InputDecoration(
                                  hintText: '자기소개 입력', // 힌트 텍스트
                                  border: InputBorder.none, // 테두리 제거
                                  isCollapsed: true, // 내부 패딩 해제하여 상단 정렬에 영향 없음
                                  contentPadding: EdgeInsets.zero, // 텍스트와 상단 사이 여백 제거
                                ),
                                textAlignVertical: TextAlignVertical.top, // 텍스트를 상단 정렬
                                maxLines: 3, // 텍스트가 여러 줄로 확장 가능하도록 설정
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 프로필 수정 버튼과 식물 개수 (원래 위치 유지)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyPageEditScreen()),
                            );
                          },
                          child: Text('수정 완료'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            foregroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.eco, color: Colors.green),
                              SizedBox(width: 4),
                              Text(
                                '$plantCount',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 4,
              endIndent: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                '나의 게시물 : ${imagePaths.length}개',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          _onItemTapped(index);
          // 네비게이션 로직 추가
          if (index == 0) {
            // Example: MainScreen으로 이동
            Navigator.pushReplacementNamed(context, '/main');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/plants');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    ),
    Positioned(
      bottom: 70, // 네비게이션 바 위쪽
      left: MediaQuery.of(context).size.width / 2 - 50, // 화면 중앙 정렬 좌표 계산
      child: TextButton(
        onPressed: () {
          print("");
        },
        child: Text(
          '계정 탈퇴',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    ),
    ],
    );
  }
}
