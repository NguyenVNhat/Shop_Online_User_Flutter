import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:flutter_user_github/models/Dto/UserDto.dart';
import 'package:flutter_user_github/models/Dto/UserRegisterDto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });
  Future<Response> login(Userdto dto) async {
    return await apiClient.postData(Appconstant.LOGIN_URL, dto.toJson());
  }

  Future<Response> logout(String token) async {
    return await apiClient.postData(Appconstant.LOGOUT_URL, token);
  }

  Future<Response> register(Userregisterdto dto) async {
    return await apiClient.postData(Appconstant.REGISTER_URL, dto.toJson());
  }

  Future<Response> sendotp(String email) async {
    return await apiClient
        .postData(Appconstant.SENDOTP_URL.replaceFirst("{email}", email),null);
  }

  Future<Response> verifyotp(
      String email, String otp, String newpassword) async {
        String url =Appconstant.VERIFYOTP_URL
        .replaceFirst("{email}", email)
        .replaceFirst("{otp}", otp)
        .replaceFirst("{newpassword}", newpassword);
      print(url);
    return await apiClient.postData(url,null);
  }

  saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(Appconstant.TOKEN, token);
  }
}
