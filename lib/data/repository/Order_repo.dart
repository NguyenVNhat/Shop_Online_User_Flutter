import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:get/get.dart';

class OrderRepo {
  final ApiClient apiClient;
  OrderRepo({
    required this.apiClient,
  });
  Future<Response> getall() async {
    return await apiClient.getData(Appconstant.ORDERT_URL);
  }

  Future<Response> getorderbyordercode(String ordercode) async {
    return await apiClient.getData(Appconstant.ORDER_BY_ORDERCODE_URL
        .replaceFirst("{ordercode}", ordercode));
  }

  Future<Response> getorderbyorderstatus(String status) async {
    return await apiClient.getData(
        Appconstant.ORDER_BY_ORDERSTATUS_URL.replaceFirst("{status}", status));
  }
   Future<Response> updatefeedback(int orderId) async {
    return await apiClient.postData(
        Appconstant.ORDER_UPDATE_FEEDBACK_URL.replaceFirst("{orderid}", orderId.toString()),null);
  }
  Future<Response> cancelorder(String ordercode) async {
    return await apiClient.postData(
        Appconstant.ORDERT_CANCEL_URL.replaceFirst("{ordercode}",ordercode),null);
  }
}
