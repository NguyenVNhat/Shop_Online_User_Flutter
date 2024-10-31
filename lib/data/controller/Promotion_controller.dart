import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/data/repository/Promotion_repo.dart';
import 'package:flutter_user_github/models/Dto/PromotionDto.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/PromotionModel.dart';
import 'package:flutter_user_github/models/Model/PromotionOfStoreModel.dart';
import 'package:flutter_user_github/models/Model/UserPromotionModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PromotionController extends GetxController {
  final PromotionRepo promotionRepo;
  PromotionController({
    required this.promotionRepo,
  });

  Storecontroller storecontroller = Get.find<Storecontroller>();
  bool? loading;
  bool? get getloading =>loading;
  List<PromotionData> listpromotion = [];
  List<PromotionData> get getlistpromotion => listpromotion;

  Future<void> getall() async{
    loading = true;
    Response response = await promotionRepo.getall();
    if(response.statusCode == 200){
      var data = response.body;
      listpromotion = [];
      listpromotion.addAll(Promotionmodel.fromJson(data).getlistpromotion ?? []);
    }
    else{
      print("Lỗi lấy khuyến mãi ${response.statusCode}");
    }
    loading = false;
    update();
    
  }
  List<PromotionData> listpromotionByStoreId = [];
  List<PromotionData> get getlistpromotionByStoreId => listpromotionByStoreId;
  bool? loadingByStoreId = false;
  bool? get getloadingStoreId =>loadingByStoreId;

  Future<void> getbystoreid(int storeid) async{
    listpromotionByStoreId = [];
    loadingByStoreId = true;
    Response response = await promotionRepo.getbystoreid(storeid);
    if(response.statusCode == 200){
      var data = response.body;
      listpromotionByStoreId.addAll(Promotionmodel.fromJson(data).getlistpromotion ?? [] );
      print("Lấy danh sách khuyến mãi thành công");
    }
    else{
      print("Lỗi lấy khuyến mãi ${response.statusCode}");
    }
    loadingByStoreId = false;
    update();
  }
  List<DisplayPromotionData> listPromotionOfStore = [];
  List<DisplayPromotionData> get getlistPromotionOfStore => listPromotionOfStore;
  bool? loadingDisplay = false;
  bool? get getloadingDisplay => loadingDisplay;
  Future<void> getAllPromotionOfStore() async{
    loadingDisplay = true;
      for(Storesitem item in storecontroller.storeList){
        Response response = await promotionRepo.getbystoreid(item.storeId!);
        if(response.statusCode == 200){
          listPromotionOfStore = [];
          var data = response.body;
          listPromotionOfStore.add(DisplayPromotionData(storesitem: item,promotionDataOfStore: Promotionofstoremodel.fromJson(data).getlistPromotion ?? []));
        }
      }
      loadingDisplay = false;
    update();
  }

  List<UserPromotionData> listuserpromotion = [];
  List<UserPromotionData> get getlistuserpromotion => listuserpromotion;
  bool loadPromotionOfUser = false;
  bool get getloadPromotionOfUser => loadPromotionOfUser;
  Future<void> getListPromotionOfUer()async{
    loadPromotionOfUser = true;
    Response response = await promotionRepo.getbyuser();
    if(response.statusCode == 200){
        listuserpromotion = [];
        var data = response.body;
        listuserpromotion.addAll(UserPromotionModel.fromJson(data).getlistpromotion ?? []);
    }
    else{
      print("Lỗi không lấy được danh sách giảm giá ${response.statusCode}");
      listuserpromotion = [];
    }
    loadPromotionOfUser = false;
    update();
  }
  Future<void> getUserPromotionWithStoreId(int storeId)async{
    loadPromotionOfUser = true;
    Response response = await promotionRepo.getUserPromotionByStore(storeId);
    if(response.statusCode == 200){
        listuserpromotion = [];
        var data = response.body;
        listuserpromotion.addAll(UserPromotionModel.fromJson(data).getlistpromotion ?? []);
    }
    else{
      print("Lỗi không lấy được danh sách giảm giá ${response.statusCode}");
      listuserpromotion = [];
    }
    loadPromotionOfUser = false;
    update();
  }



  bool checkPromotion(String promotionCode){
    for(UserPromotionData item in listuserpromotion){
      if(item.promotionCode == promotionCode){  
        return false;
      }
    }
    return true;
  }
  Future<void> savepromotion(Promotiondto dto) async{
    Response response = await promotionRepo.savepromotion(dto);
    if(response.statusCode == 200){
      getListPromotionOfUer();
        Get.snackbar(
          "Thông báo",
          "Lưu mã giảm giá thành công",
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
    else{
      print("Lưu mã giảm giá thất bại ${response.body}");
    }
  }
 
}
