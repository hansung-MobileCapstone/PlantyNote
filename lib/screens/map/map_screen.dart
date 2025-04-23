import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  void _onItemTapped(int index) { // 인덱스 상태관리
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getGeoData() async {
    // 위치 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return Future.error('위치 권한이 없습니다.');
      }
    }

    Position position = await Geolocator.getCurrentPosition(); // 현재 위치 가져오기

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // 현재 위치로 이동
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition!,
            zoom: 18,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.583078, 127.010667), // 한성대학교
              zoom: 18,
            ),
            zoomGesturesEnabled: true,
            myLocationEnabled: true, // 내 위치 아이콘
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller; // 구글맵 컨트롤러
            },
          ),
          Positioned( // 현재 위치 버튼
            bottom: 90,
            right: 15,
            child: _currentLocationButton(),
          ),
          Positioned( // 식물 등록 버튼
            bottom: 30,
            right: 16,
            child: _writeButton(),
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
      iconSize: 45,
      onPressed: getGeoData,
      tooltip: '내 위치로 이동',
    );
  }

  // 식물 등록 버튼 위젯
  Widget _writeButton() {
    return IconButton(
      onPressed: () {
        context.push('/map/create');
      },
      icon: const Icon(
        Icons.add_circle,
        color: Color(0xFF4B7E5B),
        size: 45,
      ),
    );
  }

}
