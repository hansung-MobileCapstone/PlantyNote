import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/components/bottom_navigation_bar.dart';
import 'package:plant/widgets/components/plant_expert_banner.dart';

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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnapshot.data;
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("로그인 후 이용해주세요.")),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  _searchBar(),
                  const SizedBox(height: 18),
                  _mainContent(),
                  const SizedBox(height: 30),
                  const PlantExpertBanner(),
                  const SizedBox(height: 30),
                  _recentPosts(user),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          bottomNavigationBar: MyBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        );
      },
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
            context.push('/main/notifications'); // 푸시알림페이지로 이동
          },
        ),
      ],
    );
  }

  // 상단 로고 위젯
  Widget _logoImage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 32,
        ),
        const SizedBox(width: 7),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        // 리플 효과
        onTap: () {
          context.go('/main/search'); // /main/search로 이동
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0x264B7E5B),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: const [
              SizedBox(width: 16),
              Icon(Icons.search, color: Color(0xFFB3B3B3)),
              SizedBox(width: 8),
              Text(
                '궁금한 식물을 검색해 보세요!',
                style: TextStyle(color: Color(0xFFB3B3B3)),
              ),
            ],
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/main_plant.png',
              width: 280,
              height: 380,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }

  // 최근 게시물
  Widget _recentPosts(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Text(
                '전체 게시물',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 18),
                onPressed: () {
                  context.push('/community'); // 전체게시물페이지로 이동
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _makeCarousel(user),
      ],
    );
  }

  // 캐러셀 (Firestore에서 게시글 가져오기)
  Widget _makeCarousel(User user) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _defaultCarousel();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _defaultCarousel();
        }

        final docs = snapshot.data!.docs;

        // 이미지 URL과 docId를 함께 추출하여 리스트 생성
        final List<Map<String, String>> posts = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final imageUrlList = List<String>.from(data['imageUrl'] ?? []);
          final firstImageUrl = imageUrlList.isNotEmpty ? imageUrlList[0] : null;

          return {
            'imageUrl': firstImageUrl ?? 'assets/images/default_post.png', // 기본 이미지 경로 설정
            'docId': doc.id,
          };
        }).toList(); // where 필터 제거

        final limitedPosts = posts.take(5).toList();

        if (limitedPosts.isEmpty) {
          return _defaultCarousel();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CarouselSlider(
            items: limitedPosts.map((post) {
              return _carouselImageItem(post['imageUrl']!,
                  docId: post['docId']!);
            }).toList(),
            options: CarouselOptions(
              height: 130,
              viewportFraction: 0.4,
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: false,
              initialPage: 0,
            ),
          ),
        );
      },
    );
  }

  // 기본 캐러셀 (오류 또는 데이터 없음 시)
  Widget _defaultCarousel() {
    final defaultImages = [
      'assets/images/default_post.png',
      'assets/images/default_post.png',
      'assets/images/default_post.png',
      'assets/images/default_post.png',
      'assets/images/default_post.png',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CarouselSlider(
        items: defaultImages.map((imagePath) {
          return _carouselImageItem(imagePath, isAsset: true);
        }).toList(),
        options: CarouselOptions(
          height: 200,
          viewportFraction: 0.4,
          enableInfiniteScroll: false,
          autoPlay: false,
          enlargeCenterPage: false,
          initialPage: 0,
        ),
      ),
    );
  }

  // 캐러셀 이미지 아이템
  Widget _carouselImageItem(String imageUrl, {bool isAsset = false, String? docId}) {
    final double itemWidth = 150;
    final double itemHeight = 150;

    return GestureDetector(
      onTap: () {
        if (docId != null) {
          context.push('/community/detail', extra: {'docId': docId});
        }
      },
      child: Container(
        width: itemWidth,
        margin: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          // imageUrl이 asset 경로인지 자동 체크하여 처리
          child: imageUrl.startsWith('assets/')
              ? Image.asset(
                  imageUrl,
                  width: itemWidth,
                  height: itemHeight,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  imageUrl,
                  width: itemWidth,
                  height: itemHeight,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_image.png',
                      width: itemWidth,
                      height: itemHeight,
                      fit: BoxFit.cover,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
