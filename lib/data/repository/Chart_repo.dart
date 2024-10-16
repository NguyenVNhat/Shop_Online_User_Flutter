import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:flutter_user_github/models/Dto/ChartDto.dart';
import 'package:get/get.dart';

class ChartRepo {
  final ApiClient apiClient;
  ChartRepo({
    required this.apiClient,
  });
  Future<Response> getChart() async {
    return await apiClient.getData(Appconstant.CHART_URL);
  }
  Future<Response> getlistChart(int idreceiver) async {
    return await apiClient.getData(Appconstant.GETLISTCHART_URL.replaceFirst("{receiverid}", idreceiver.toString()));
  }
   Future<Response> sendImage(int idsender,int idreceiver,String image) async {
    Chartdto chartdto = Chartdto(sender: idsender, receiver: idreceiver, message: "", imageBase64: image, isRead: true);
    return await apiClient.postData(Appconstant.SAVE_CHART_IMAGE,chartdto.toJson());
  }
}
