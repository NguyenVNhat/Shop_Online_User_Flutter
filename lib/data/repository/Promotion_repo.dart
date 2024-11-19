import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:flutter_user_github/models/Dto/PromotionDto.dart';
import 'package:get/get.dart';

class PromotionRepo {
  final ApiClient apiClient;
  PromotionRepo({required this.apiClient});
  Future<Response> getall() async {
    return await apiClient.getData(Appconstant.PROMOTION_URL);
  }
  Future<Response> getbystoreid(int storeid) async {
    return await apiClient.getData(Appconstant.PROMOTION_BYSTOREID_URL.replaceFirst("{storeId}", storeid.toString()));
  }
  Future<Response> getbyuser() async {
    return await apiClient.getData(Appconstant.USER_PROMOTION_URL);
  }
   Future<Response> savepromotion(int voucherId) async {
    return await apiClient.postData(Appconstant.SAVE_PROMOTION_URL.replaceFirst("{voucherId}", voucherId.toString()),null);
  }


 
}
