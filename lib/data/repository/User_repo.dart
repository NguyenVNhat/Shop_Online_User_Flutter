import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/models/Dto/AnnouceDto.dart';
import 'package:flutter_user_github/models/Dto/RegisterShipperDto.dart';
import 'package:flutter_user_github/models/Dto/UserUpdateDto.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../api/AppConstant.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});
  Future<Response> getuserprofile() async {
    return await apiClient.getData(Appconstant.USER_PROFILE_URL);
  }

  Future<Response> updateprofile(Userupdatedto updatedto) async {
    return await apiClient.putData(Appconstant.USER_UPDATE_PROFILE_URL, updatedto.toJson());
  }

  Future<Response> registershipper(Registershipperdto dto) async {
    return await apiClient.postData(Appconstant.REGISTER_SHIPPER_URL, dto.toJson());
  }
  Future<Response> getannounce() async{
    return await apiClient.getData(Appconstant.ANNOUNCE_URL);
  }
  Future<Response> addannouce(Annoucedto dto) async{
    return await apiClient.postData(Appconstant.ANNOUNCE_ADD_URL,dto.toJson());
  }


  
}
