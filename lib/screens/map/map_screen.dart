import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/components/bottom_navigation_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedIndex = 2; // 네비게이션바 인덱스
  GoogleMapController? _mapController; // 구글맵 컨트롤러
  LatLng? _currentPosition;
  BitmapDescriptor? _customIcon; // 커스텀 마커

  @override
  void initState() {
    super.initState();
    _checkLocation(); // 위치 요청
    _loadCustomMarker(); // 커스텀 마커 로드
  }

  // 커스텀 마커 로드
  Future<void> _loadCustomMarker() async {
    _customIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(38, 48)),
      'assets/images/map_marker.png',
    );
    setState(() {});
  }

  // 현재 위치 요청
  Future<void> _checkLocation() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      final newPermission = await Geolocator.requestPermission();
      if (newPermission != LocationPermission.always && newPermission != LocationPermission.whileInUse) return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 18),
        ),
      );
    }
  }

  void _onItemTapped(int index) { // 인덱스 상태관리
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Marker 표시
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('maps') // maps 컬렉션
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('에러: \${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator()); // 로딩스피너
              }

              // 위도, 경도(lat, lng)로 그룹핑
              final docs = snapshot.data!.docs;
              final grouped = <LatLng, List<QueryDocumentSnapshot>>{};
              for (var doc in docs) {
                final data = doc.data()! as Map<String, dynamic>;
                final lat = data['lat'] as double;
                final lng = data['lng'] as double;
                final key = LatLng(lat, lng);
                grouped.putIfAbsent(key, () => []).add(doc);
              }

              // 그룹별 Marker 생성
              final markers = grouped.entries.map((entry) {
                final latlng = entry.key;
                final docList = entry.value;
                final markerId = '${latlng.latitude}_${latlng.longitude}';
                return Marker(
                  markerId: MarkerId(markerId),
                  position: latlng,
                  icon: _customIcon ?? BitmapDescriptor.defaultMarker,
                  onTap: () {
                    // 지도식물상세 페이지로 이동
                    context.push('/map/detail', extra: docList);
                  },
                );
              }).toSet();

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition ?? LatLng(37.583078, 127.010667),
                  zoom: 18,
                ),
                zoomGesturesEnabled: true,
                myLocationEnabled: true, // 내 위치 아이콘
                myLocationButtonEnabled: false,
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller; // 구글맵 컨트롤러
                },
              );
            },
          ),
          Positioned( // 현재 위치 버튼
            bottom: 90,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _currentLocationButton(),
            ),
          ),
          Positioned( // 식물 등록 버튼
            bottom: 30,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _writeButton(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
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
        '우리 동네 식물 지도',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 현재위치 버튼 위젯
  Widget _currentLocationButton() {
    return IconButton(
      icon: Icon(Icons.my_location),
      color: Colors.red,
      iconSize: 40,
      onPressed: _checkLocation,
      tooltip: '내 위치로 이동',
    );
  }

  // 식물 등록 버튼 위젯
  Widget _writeButton() {
    return IconButton(
      onPressed: () {
        if (_currentPosition != null) {
          context.push('/map/create', extra: _currentPosition); // 위치 전달
        } else {
          Fluttertoast.showToast(
            msg: "현재 위치를 불러오는 중입니다..",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color(0xFF4B7E5B),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      icon: const Icon(
        Icons.add_circle,
        color: Color(0xFF4B7E5B),
        size: 40,
      ),
    );
  }


}