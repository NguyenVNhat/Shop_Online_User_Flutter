import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:get/get.dart';

class PromotionRepo {
  final ApiClient apiClient;
  PromotionRepo({required this.apiClient});
  Future<Response> getall() async {
    return await apiClient.getData(Appconstant.PROMOTION_URL);
  }
  Future<Response> getbystoreid(int storeid) async {
    return await apiClient.getData(Appconstant.PROMOTION_BYSTOREID_URL.replaceFirst("{id}", storeid.toString()));
  }

 
}
