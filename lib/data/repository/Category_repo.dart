import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:get/get.dart';

class CategoryRepo {
  final ApiClient apiClient;
  CategoryRepo({
    required this.apiClient,
  });
  Future<Response> getall() async {
    return await apiClient.getData(Appconstant.CATEGORY_URL);
  }
  Future<Response> getbystoreid(int id) async {
    return await apiClient.getData(Appconstant.CATEGORY_BYSTOREID_URL.replaceFirst("{storeid}", id.toString()));
  }
}
