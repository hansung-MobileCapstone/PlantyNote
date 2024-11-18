import 'package:flutter/material.dart';
import 'my_page_edit_screen.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  int _selectedIndex = 0;

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
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar 설정은 이전과 동일합니다.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20.0),
          child: Text(
            'MY 프로필',
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
                '로그아웃',
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
              height: 150,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '마이클',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '안녕하세요, 초보 식집사입니다.',
                              style: TextStyle(
                                color: Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 프로필 수정 버튼과 식물 개수
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // 프로필 수정 화면으로 이동
                           /* Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyPageEditScreen()),
                            ); */
                          },
                          child: Text('프로필 수정'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            foregroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0, // 경계선 제거
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                if (_selectedIndex == 0)
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    height: 3,
                    width: 105,
                    color: Colors.green[800],
                  ),
                Icon(Icons.eco),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                if (_selectedIndex == 1)
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    height: 3,
                    width: 105,
                    color: Colors.green[800],
                  ),
                Icon(Icons.book),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                if (_selectedIndex == 2)
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    height: 3,
                    width: 105,
                    color: Colors.green[800],
                  ),
                Icon(Icons.person),
              ],
            ),
            label: '',
          ),
        ],
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
