import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 주소 포맷팅 -> android, ios가 다르게 나와서
String formatAddress(Placemark place) {
  final street = place.street ?? '';
  final isStreetInvalid = street.trim().toLowerCase() == 'south korea';

  final fallbackStreet = [
    place.thoroughfare,
    place.subThoroughfare
  ].where((e) => e != null && e.isNotEmpty).join(' ');

  return [
    place.administrativeArea, // 시
    place.subAdministrativeArea?.isNotEmpty == true
        ? place.subAdministrativeArea
        : place.subLocality,   // 구/동
    isStreetInvalid ? fallbackStreet : street // 도로명
  ].where((e) => e != null && e.isNotEmpty).join(' ');
}

// 좌표를 주소로 매핑
Future<String> latLngToAddressString(LatLng latLng) async {
  try {
    final placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    return formatAddress(placemarks.first);
  } catch (e) {
    return '주소를 불러올 수 없습니다';
  }
}

// 주소를 좌표로 매핑
Future<LatLng?> addressToLatLng(String address) async {
  try {
    final locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      final loc = locations.first;
      return LatLng(loc.latitude, loc.longitude);
    }
  } catch (e) {
    print('주소 변환 실패: $e');
  }
  return null;
}