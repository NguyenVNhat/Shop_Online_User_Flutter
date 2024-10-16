import 'dart:io';

import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/data/repository/Auth_repo.dart';
import 'package:flutter_user_github/data/repository/User_repo.dart';
import 'package:flutter_user_github/models/Dto/AnnouceDto.dart';
import 'package:flutter_user_github/models/Dto/RegisterShipperDto.dart';
import 'package:flutter_user_github/models/Dto/UserDto.dart';
import 'package:flutter_user_github/models/Dto/UserRegisterDto.dart';
import 'package:flutter_user_github/models/Dto/UserUpdateDto.dart';
import 'package:flutter_user_github/models/Model/AnnounceModel.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart' as get_multipart;

import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({
    required this.userRepo,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _userprofile;
  User? get userprofile => _userprofile;

  Future<void> getuserprofile() async {
    _isLoading = true;
    update();
    Response response = await userRepo.getuserprofile();
    if (response.statusCode == 200) {
      var data = response.body;
      _userprofile = Usermodel.fromJson(data).getuser;
    } else {}
    _isLoading = false;
    update();
  }

  String? base64Image = null;
  void updateAvatar(String newimage) {
  base64Image = newimage;
  update();
}


  Future<void> updateprofile(Userupdatedto updatedto) async {
    _isLoading = true;
    update();

    Response response = await userRepo.updateprofile(updatedto);
    if (response.statusCode == 200) {
      Get.snackbar("Thông báo", "Cập nhật thành công");
      getuserprofile();
    } else {
      Get.snackbar("Thông báo", "Lỗi đã xảy ra ${response.statusCode}");
    }
    _isLoading = false;
    update();
  }

   Future<bool> registershipper(Registershipperdto dto) async {
    update();

    Response response = await userRepo.registershipper(dto);
    if (response.statusCode == 200) {
        return true;
    } else {
      return false;
    }
    
  }
  List<AnnounceData> listannouce = [];
  List<AnnounceData> get getlistannouce => listannouce;
  bool loadingannouce = false;
  bool get getloadingannouce =>loadingannouce;
  Future<void> getannounce()async{
      loadingannouce = true;
      Response response = await userRepo.getannounce();
      if(response.statusCode == 200){
        var data = response.body;
        
        listannouce = [];
        listannouce.addAll(Announcemodel.fromJson(data).getannounce ?? []);
       
      }
      else{
        print("Lỗi lấy thông báo ${response.statusCode}");
      }
      loadingannouce = false;
      update();
  }
  Future<void> addannouce(String title,String content) async{
    int userid = _userprofile!.id!;
    Annoucedto annoucedto = Annoucedto(userid: userid, title: title, content: content);
    Response response = await userRepo.addannouce(annoucedto);
    if(response.statusCode !=200){
      print("Lỗi không thêm được thông báo ${response.statusCode}");
    }
  }
}
