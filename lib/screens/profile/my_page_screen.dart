import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/bottom_navigation_bar.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  MyPageScreenState createState() => MyPageScreenState();
}

class MyPageScreenState extends State<MyPageScreen> {
  int _selectedIndex = 2; // 네비게이션 인덱스

  // 사용자 정보 변수
  String _nickname = ''; // 이름 (닉네임)
  String _bio = ''; // 소개문
  String? _profileImageUrl; // 프로필 이미지 URL 추가

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 식물 개수는 Firestore에서 동적으로 가져옵니다.
  int _plantCount = 0;

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _nickname = userDoc.get('nickname') ?? '';
            _bio = userDoc.get('bio') ?? '';
            _profileImageUrl = userDoc.get('profileImage') as String?;
          });

          // 사용자의 식물 개수 가져오기 (예시: 'plants' 컬렉션을 사용한다고 가정)
          QuerySnapshot plantSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('plants') // 식물이 저장된 컬렉션 이름
              .get();

          setState(() {
            _plantCount = plantSnapshot.docs.length;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // 사용자 데이터 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(), // 상단 바
      body: Padding(
        padding: const EdgeInsets.only(right: 18.0, left: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // 프로필 박스
              height: 150,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFC9DDD0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _profileImage(), // 프로필 이미지
                      SizedBox(width: 16),
                      _profileInfo(), // 닉네임, 소개글
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        _editProfileButton(), // 프로필 수정 버튼
                        SizedBox(width: 10),
                        _plantsNumber(), // 내식물모음페이지에 있는 식물 개수
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(
              // 구분선
              color: Color(0xFF4B7E5B),
              thickness: 0.7,
              indent: 5,
              endIndent: 5,
            ),
            _myPostsNumber(),
            SizedBox(height: 12),
            Expanded(
              child: _myPosts(), // 나의 게시물들
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        // 하단 네비게이션바
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // 상단 바
  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'MY 프로필',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // 오른쪽 끝 배치
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            // 로그아웃 버튼
            onTap: () {
              _showLogoutDialog(context);
            },
            child: Text(
              '로그아웃',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 로그아웃 확인 팝업
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("로그아웃"),
          content: Text("로그아웃 하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
              },
              child: Text("아니오"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // 로그아웃 처리
                context.go('/start/login'); // 로그인페이지로 이동
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }

  // 프로필 사진
  Widget _profileImage() {
    String? displayImageUrl = _profileImageUrl;

    if (displayImageUrl != null && displayImageUrl.startsWith('http')) {
      // 캐시 무효화를 위해 타임스탬프 추가
      displayImageUrl = '$displayImageUrl?${DateTime.now().millisecondsSinceEpoch}';
    }

    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: displayImageUrl != null && displayImageUrl.startsWith('http')
            ? NetworkImage(displayImageUrl)
            : AssetImage('assets/images/basic_profile.png') as ImageProvider,
      ),
    );
  }

  // 닉네임, 소개글
  Widget _profileInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // 닉네임
            _nickname.isNotEmpty ? _nickname : '이름 없음',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B7E5B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            // 소개 글
            _bio.isNotEmpty ? _bio : '소개문을 입력해주세요.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF4B7E5B),
            ),
          ),
        ],
      ),
    );
  }

  // 프로필 수정 버튼
  Widget _editProfileButton() {
    return ElevatedButton(
      onPressed: () async {
        // 프로필 수정 페이지로 이동 후, 업데이트 여부에 따라 데이터 다시 가져오기
        final isUpdated = await context.push<bool>('/profile/edit');
        if (isUpdated == true) {
          _fetchUserData(); // 데이터 다시 가져오기
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4B7E5B),
        foregroundColor: Colors.white,
      ),
      child: Text('프로필 수정'),
    );
  }

  // 내식물모음페이지에 있는 식물 개수
  Widget _plantsNumber() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Icon(
            Icons.eco,
            color: Color(0xFF4B7E5B),
          ),
          SizedBox(width: 4),
          Text(
            '$_plantCount',
            style: TextStyle(
              color: Color(0xFF4B7E5B),
            ),
          ),
        ],
      ),
    );
  }

  // 나의 게시물 개수
  Widget _myPostsNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Text(
        '나의 게시물 : ',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  // 나의 게시물들
  Widget _myPosts() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('로그인 후 이용해주세요.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('작성한 게시물이 없습니다.'));
        }

        final docs = snapshot.data!.docs;

        // 이미지 URL만 추출하여 리스트 생성
        final imageUrls = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final imageUrlList = List<String>.from(data['imageUrl'] ?? []);
          return imageUrlList.isNotEmpty ? imageUrlList[0] : null;
        }).where((url) => url != null).cast<String>().toList();

        if (imageUrls.isEmpty) {
          return Center(child: Text('게시물에 이미지가 없습니다.'));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // 클릭 시 상세 페이지로 이동, docId 전달 필요
                final docId = docs[index].id;
                context.push('/community/detail', extra: {'docId': docId});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_image.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
