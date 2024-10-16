import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:get/get.dart';

class SizeRepo {
  final ApiClient apiClient;
  SizeRepo({required this.apiClient});
  Future<Response> getall() async {
    return await apiClient.getData(Appconstant.SIZE_URL);
  }

  Future<Response> getbyid(int id) async {
    return await apiClient.getData(
        Appconstant.SIZE_BY_ID_URL.replaceFirst(("{id}"), id.toString()));
  }
}
