import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FunctionMap {
  FunctionMap();
  // Tính khoảnh cách hai tọa độ
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceInMeters;
  }

  // Lấy tọa độ từ địa chỉ
  Future<Point> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;
        return Point(latitude: latitude, longtitude: longitude);
      }
    } catch (e) {
      print('Error: $e');
    }
    return Point(latitude: 0, longtitude: 0);
  }

  // Lấy tọa độ từ thiết bị
  Future<Point> getCurrentLocation() async {
    // Request location permissions

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return Point(latitude: position.latitude, longtitude: position.longitude);
  }

  // format time
  String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('hh:mm').format(dateTime);
  }

  // List province
  Future<List<String>> listProvinces() async {
    String url = 'https://provinces.open-api.vn/api/?depth=2';
    List<String> provinceNames = [];

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);

        // Giải mã JSON từ chuỗi đã giải mã
        List<dynamic> data = jsonDecode(decodedResponse);
        provinceNames =
            data.map((province) => province['name'] as String).toList();
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      print("Error: $e");
    }
    return provinceNames;
  }

  Future<List<String>> listDistrict(String provinceName) async {
    String url = 'https://provinces.open-api.vn/api/?depth=2';
    List<String> districtNames = [];

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);


        List<dynamic> provinces = jsonDecode(decodedResponse);

        var province = provinces.firstWhere(
            (element) => element['name'] == provinceName,
            orElse: () => null);

        if (province != null) {
          List<dynamic> districts = province['districts'] ?? [];

          districtNames =
              districts.map((district) => district['name'] as String).toList();
        } else {
          throw Exception('Province not found');
        }
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      print("Error: $e");
    }

    return districtNames;
  }
}

class Point {
  double? latitude;
  double? longtitude;
  Point({
    required this.latitude,
    required this.longtitude,
  });
}

class Province {
  List<String> listProvinces() {
    List<String> provinces = [
      'Hà Nội',
      'Hồ Chí Minh',
      'Đà Nẵng',
      'Hải Phòng',
      'Cần Thơ',
      'Nghệ An',
      'Thanh Hóa',
      'Đồng Nai',
      'Bình Dương',
      'Khánh Hòa',
      'Thừa Thiên Huế',
      'An Giang',
      'Bà Rịa-Vũng Tàu',
      'Bắc Ninh',
      'Nam Định',
      'Vĩnh Long',
      'Bắc Giang',
      'Hưng Yên',
      'Hà Nam',
      'Quảng Ninh',
      'Đắk Lắk',
      'Gia Lai',
      'Ninh Bình',
      'Hà Tĩnh',
      'Quảng Nam',
      'Thái Bình',
      'Kiên Giang',
      'Sóc Trăng',
      'Lâm Đồng',
      'Tây Ninh',
      'Bến Tre',
      'Long An',
      'Bình Thuận',
      'Hòa Bình',
      'Lạng Sơn',
      'Yên Bái',
      'Cao Bằng',
      'Điện Biên',
      'Lào Cai',
      'Sơn La',
      'Tuyên Quang',
      'Thái Nguyên',
      'Hà Giang',
      'Quảng Trị',
      'Kon Tum',
      'Ninh Thuận',
      'Bắc Kạn',
      'Đắk Nông',
      'Hải Dương',
      'Phú Thọ',
      'Vĩnh Phúc',
      'Đồng Tháp',
      'Hậu Giang',
      'Trà Vinh',
      'Bạc Liêu',
      'Cà Mau',
    ];
    return provinces;
  }

  Future<List<String>> fetchProvinces() async {
    String url = 'https://provinces.open-api.vn/api/?depth=2';
    List<String> provinceNames = [];

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        provinceNames =
            data.map((province) => province['name'] as String).toList();
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      print("Error: $e");
    }

    return provinceNames;
  }
}
