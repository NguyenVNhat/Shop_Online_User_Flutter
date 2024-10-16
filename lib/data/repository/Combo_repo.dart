import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:flutter_user_github/models/Dto/OrderComboDto.dart';
import 'package:get/get.dart';

class ComboRepo {
  final ApiClient apiClient;
  ComboRepo({
    required this.apiClient,
  });
  Future<Response> getall() async {
    return await apiClient.getData(Appconstant.COMBO_URL);
  }

  Future<Response> getbyid(int id) async {
    String url =
        Appconstant.COMBO_BY_COMBOID_URL.replaceFirst("{id}", id.toString());
    return await apiClient.getData(url);
  }
  Future<Response> order(Ordercombodto dto) async {
    return await apiClient.postData(Appconstant.ORDER_COMBO_2_URL,dto.toJson());
  }
}
