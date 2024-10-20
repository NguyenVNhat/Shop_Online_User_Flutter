import 'package:flutter_user_github/data/repository/User_repo.dart';
import 'package:flutter_user_github/models/Dto/AnnouceDto.dart';
import 'package:flutter_user_github/models/Dto/RegisterShipperDto.dart';
import 'package:flutter_user_github/models/Dto/UserUpdateDto.dart';
import 'package:flutter_user_github/models/Model/AnnounceModel.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter/material.dart';
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

  Future<User?> getbyid(int id)async{
    Response response = await userRepo.getbyid(id);
    if (response.statusCode == 200) {
      var data = response.body;
      return Usermodel.fromJson(data).getuser!;
    }
    else{
      print("Lỗi tìm người dùng");
    }
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
      Get.snackbar(
            "Thông báo",
            "Cập nhật thành công",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            icon: Icon(Icons.card_giftcard_sharp, color: Colors.green),
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 1),
            isDismissible: true,
            
          );
      getuserprofile();
    } else {
      Get.snackbar(
            "Thông báo",
            "Lỗi đã xảy ra . Vui lòng thử lại sau",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            icon: Icon(Icons.card_giftcard_sharp, color: Colors.green),
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 1),
            isDismissible: true,
            
          );
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
  Future<void> addannouceV2( int userid,String title,String content) async{
    Annoucedto annoucedto = Annoucedto(userid: userid, title: title, content: content);
    Response response = await userRepo.addannouce(annoucedto);
    if(response.statusCode !=200){
      print("Lỗi không thêm được thông báo ${response.statusCode}");
    }
  }
}
