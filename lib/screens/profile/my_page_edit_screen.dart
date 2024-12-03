import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 사진 선택 및 업로드 함수
  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (!mounted) return;
      setState(() {
        _image = image;
      });
      // 업로드 및 Firestore 업데이트
      await _uploadProfileImage(File(_image!.path));
    }
  }


  // 이미지 업로드 함수
  Future<void> _uploadProfileImage(File imageFile) async {
    try {
      if (_user == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${_user!.uid}.jpg');
      await storageRef.putFile(imageFile);

      // 업로드된 이미지의 URL 가져오기
      String downloadUrl = await storageRef.getDownloadURL();

      // Firestore에 이미지 URL 업데이트
      await _firestore.collection('users').doc(_user!.uid).update({
        'profileImage': downloadUrl,
      });

      if (!mounted) return; // 위젯이 마운트되어 있는지 확인

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      Fluttertoast.showToast(
        msg: "프로필 이미지가 업데이트되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFF4B7E5B),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Error uploading profile image: ${e.toString()}');
      Fluttertoast.showToast(
        msg: "이미지 업로드 실패: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _nameController = TextEditingController();
    _introController = TextEditingController();
    if (_user != null) {
      _fetchUserData();
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
          if (!mounted) return; // 위젯이 마운트되어 있는지 확인
          setState(() {
            _nameController.text = data['nickname'] ?? '';
            _introController.text = data['bio'] ?? '';
            _profileImageUrl = data['profileImage'] as String?;

            // 프로필 이미지 URL이 로컬 경로인 경우 null로 설정하여 기본 이미지 사용
            if (_profileImageUrl != null &&
                !_profileImageUrl!.startsWith('http')) {
              _profileImageUrl = null;
            }

            _isLoading = false; // 데이터 로딩 완료
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false; // 데이터 로딩 완료
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
      if (!mounted) return;
      setState(() {
        _isLoading = false; // 데이터 로딩 완료
      });
    }
  }


  final int plantCount = 2;

  // PW변경 모달창 호출 함수
  void _showPasswordChangeModal() {
    showDialog(
      context: context,
      builder: (context) => PasswordChangeModal(),
    );
  }

  // 이미지 경로 리스트 (게시물용)
  final List<String> imagePaths = [
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(), // 상단 바
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // 데이터 로딩 중일 때 로딩 표시
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
            _myPosts(), // 나의 게시물들
            Align(
              // 계정탈퇴 버튼
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  // 계정 탈퇴 로직
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
      automaticallyImplyLeading: false, // 뒤로가기 버튼 숨기기
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
            // PW변경 버튼
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

  // 사진 등록 ImagePicker
  Widget _imagePicker() {
    return GestureDetector(
      onTap: _pickImage, // 새로운 사진 선택 가능
      child: CircleAvatar(
        radius: 50, // 동그란 모양의 크기 (지름의 절반)
        backgroundColor: Colors.grey[200], // 배경색
        backgroundImage: _image != null
            ? FileImage(File(_image!.path))
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

  // 닉네임, 소개글 편집
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
              // 여기서 입력 제한을 제거하거나 한국어를 허용하도록 수정
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

  // 수정 완료 버튼
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

  // 프로필 저장 함수
  Future<void> _saveProfile() async {
    if (_user == null) return;
    try {
      // Firestore에 데이터 업데이트
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

      if (!mounted) return;
      Navigator.pop(context, true); // 변경 사항이 있음을 알림
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
            '$plantCount',
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
        '나의 게시물 : ${imagePaths.length}개',
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  // 나의 게시물들
  Widget _myPosts() {
    return Expanded(
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
              // 클릭 이벤트 없음
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }

  // 탈퇴 확인 팝업
  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("계정 탈퇴"),
          content: Text("정말 탈퇴 하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text("아니오"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // 계정 탈퇴 로직 구현
                  await _auth.currentUser?.delete();
                  await _firestore.collection('users').doc(_user!.uid).delete();
                  await _firestore.collection('public_users').doc(_user!.uid).delete();
                  await FirebaseStorage.instance
                      .ref()
                      .child('profile_images')
                      .child('${_user!.uid}.jpg')
                      .delete();
                  Navigator.of(context).pop(); // 팝업 닫기
                  context.go('/onboarding'); // 온보딩페이지로 이동
                  Fluttertoast.showToast(
                    msg: "계정이 성공적으로 탈퇴되었습니다.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
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
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }
}
