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
    return await apiClient.getData(Appconstant.PROMOTION_BYSTOREID_URL.replaceFirst("{id}", storeid.toString()));
  }
  Future<Response> getbyuser() async {
    return await apiClient.getData(Appconstant.USER_PROMOTION_URL);
  }
   Future<Response> savepromotion(Promotiondto dto) async {
    return await apiClient.postData(Appconstant.USER_PROMOTION_URL,dto.toJson());
  }
   Future<Response> getUserPromotionByStore(int storeId) async {
    return await apiClient.getData(Appconstant.USER_PROMOTION_BYSTOREID_URL.replaceFirst("{storeId}", storeId.toString()));
  }


 
}
