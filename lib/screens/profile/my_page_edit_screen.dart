import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/profile/change_password_modal.dart';
import 'package:plant/widgets/components/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Firebase 패키지 임포트
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class MyPageEditScreen extends StatefulWidget {
  const MyPageEditScreen({super.key});

  @override
  MyPageEditScreenState createState() => MyPageEditScreenState();
}

class MyPageEditScreenState extends State<MyPageEditScreen> {
  int _selectedIndex = 2;
  XFile? _image; // 이미지 저장 변수
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _introController;

  // Firebase 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String? _profileImageUrl;

  bool _isLoading = true; // 데이터 로딩 상태

  // 사용자 정보 변수
  String _nickname = '';
  String _bio = '';
  String? _profileImage;

  // 식물 개수
  int _plantCount = 0;

  // _onItemTapped는 한 번만 정의합니다.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _nameController = TextEditingController();
    _introController = TextEditingController();
    if (_user != null) {
      _fetchUserData();
      _fetchPlantCount();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      // Firestore에서 users 컬렉션에서 데이터 가져오기
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          if (!mounted) return; // 추가된 부분
          setState(() {
            _nickname = data['nickname'] ?? '';
            _bio = data['bio'] ?? '';
            _profileImageUrl = data['profileImage'] as String?;
            if (_profileImageUrl != null && !_profileImageUrl!.startsWith('http')) {
              _profileImageUrl = null;
            }
            _nameController.text = _nickname;
            _introController.text = _bio;
            _isLoading = false;
          });
        }
      } else {
        if (!mounted) return; // 추가된 부분
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      Fluttertoast.showToast(
        msg: "사용자 데이터 가져오기 실패: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (!mounted) return; // 추가된 부분
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPlantCount() async {
    try {
      // 사용자의 식물 개수 가져오기 (예: 'plants' 컬렉션을 사용한다고 가정)
      QuerySnapshot plantSnapshot = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('plants')
          .get();

      if (!mounted) return; // 추가된 부분
      setState(() {
        _plantCount = plantSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching plant count: $e');
    }
  }

  // 여기서 _pickImage 메서드를 추가합니다.
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  // PW변경 모달창 호출 함수
  void _showPasswordChangeModal() {
    showDialog(
      context: context,
      builder: (context) => PasswordChangeModal(),
    );
  }

  /// 탈퇴 확인 팝업
  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("계정 탈퇴"),
          content: Text("정말 탈퇴하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                dialogContext.pop(); // 팝업 닫기 using go_router
              },
              child: Text("아니오"),
            ),
            TextButton(
              onPressed: () async {
                dialogContext.pop(); // 팝업 닫기 (먼저 실행)
                await _deleteAccount(); // 비동기 함수 호출
                // 탈퇴 후 로그인 화면으로 이동
                context.go('start/login');
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      // 계정 탈퇴 로직
      await _auth.currentUser?.delete();
      await _firestore.collection('users').doc(_user!.uid).delete();
      await _firestore.collection('public_users').doc(_user!.uid).delete();
      await FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${_user!.uid}.jpg')
          .delete();

      Fluttertoast.showToast(
        msg: "계정이 성공적으로 탈퇴되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      if (!mounted) return;
      context.go('/start/login'); // 로그인 페이지로 이동
    } catch (e) {
      print('계정 탈퇴 실패: $e');
      Fluttertoast.showToast(
        msg: "계정 탈퇴 실패: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(), // 상단 바
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                      _imagePicker(), // 프로필 이미지 선택
                      SizedBox(width: 16),
                      Expanded(
                        child: _editProfileInfo(), // 닉네임, 소개글 편집
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        _editCompleteButton(), // 수정 완료 버튼
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
              child: _myPosts(), // 나의 게시물들 (동적으로 가져옴)
            ),
            Align(
              // 계정탈퇴 버튼
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  _showWithdrawDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '계정 탈퇴',
                    style: TextStyle(
                      color: Color(0xFFDA2525),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
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
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: true,
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
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
            onTap: () {
              _showPasswordChangeModal();
            },
            child: Text(
              'PW변경',
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

  Widget _imagePicker() {
    return GestureDetector(
      onTap: _pickImage, // _pickImage 메서드 호출
      child: CircleAvatar(
        radius: 50, // 동그란 모양의 크기 (지름의 절반)
        backgroundColor: Colors.grey[200],
        backgroundImage: _image != null
            ? FileImage(File(_image!.path)) // 이미지가 있으면 표시
            : (_profileImageUrl != null && _profileImageUrl!.startsWith('http'))
            ? NetworkImage(_profileImageUrl!)
            : AssetImage('assets/images/basic_profile.png') as ImageProvider,
        child: _image == null && _profileImageUrl == null
            ? Icon(
          Icons.add, // 이미지가 없을 때 추가 아이콘 표시
          color: Colors.grey[400],
          size: 30,
        )
            : null, // 이미지가 있으면 아이콘 표시 안함
      ),
    );
  }

  Widget _editProfileInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // 닉네임 TextField
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF4B7E5B),
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: _nameController,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B7E5B),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10), // 글자 수 제한 10자
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          SizedBox(height: 4),
          Container(
            // 소개글 TextField
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF4B7E5B),
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: _introController,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF4B7E5B),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editCompleteButton() {
    return ElevatedButton(
      onPressed: () async {
        await _saveProfile();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4B7E5B),
        foregroundColor: Colors.white,
      ),
      child: Text('수정 완료'),
    );
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;
    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'nickname': _nameController.text,
        'bio': _introController.text,
      });
      Fluttertoast.showToast(
        msg: "프로필이 업데이트되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFF4B7E5B),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (!mounted) return; // 추가된 부분
      context.pop(true);
    } catch (e) {
      print('Error updating profile: ${e.toString()}');
      Fluttertoast.showToast(
        msg: "프로필 업데이트 실패: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

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

  Widget _myPostsNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Text(
        '나의 게시물 : ',
        style:
        TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

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
