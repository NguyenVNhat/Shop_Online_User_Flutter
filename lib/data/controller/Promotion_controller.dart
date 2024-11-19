import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/data/repository/Promotion_repo.dart';
import 'package:flutter_user_github/models/Model/PromotionModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

class PromotionController extends GetxController {
  final PromotionRepo promotionRepo;
  PromotionController({
    required this.promotionRepo,
  });
  bool isDateBeforeToday(String inputDate) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateTime date = dateFormat.parse(inputDate);
    DateTime today = DateTime.now();
    DateTime todayOnlyDate = DateTime(today.year, today.month, today.day);
    return date.isBefore(todayOnlyDate);
  }

  Storecontroller storecontroller = Get.find<Storecontroller>();
  bool? loading;
  bool? get getloading => loading;
  List<PromotionData> listpromotion = [];
  List<PromotionData> get getlistpromotion => listpromotion;

  Future<void> getall() async {
    loading = true;
    Response response = await promotionRepo.getall();
    if (response.statusCode == 200) {
      var data = response.body;
      listpromotion = [];
      List<PromotionData> listvoucher = [];
      listvoucher.addAll(Promotionmodel.fromJson(data).getlistpromotion ?? []);
      for (PromotionData item in listvoucher) {
        if(!isDateBeforeToday(item.endDate!)){
          listpromotion.add(item);
        }
      }
      
    } else {
      print("Lỗi lấy khuyến mãi ${response.statusCode}");
    }
    loading = false;
    update();
  }

  List<PromotionData> listpromotionByStoreId = [];
  List<PromotionData> get getlistpromotionByStoreId => listpromotionByStoreId;
  bool? loadingByStoreId = false;
  bool? get getloadingStoreId => loadingByStoreId;
  Future<void> getbystoreid(int storeid) async {
    listpromotionByStoreId = [];
    loadingByStoreId = true;
    Response response = await promotionRepo.getbystoreid(storeid);
    if (response.statusCode == 200) {
      var data = response.body;
      List<PromotionData> listvoucher = [];
      listvoucher.addAll(Promotionmodel.fromJson(data).getlistpromotion ?? []);
      for (PromotionData item in listvoucher) {
        if(!isDateBeforeToday(item.endDate!)){
          listpromotionByStoreId.add(item);
        }
      }
      print("Lấy danh sách khuyến mãi thành công");
    } else {
      print("Lỗi lấy khuyến mãi ${response.statusCode}");
    }
    loadingByStoreId = false;
    update();
  }

  List<PromotionData> listpromotionByUser = [];
  List<PromotionData> get getlistpromotionByUser => listpromotionByUser;
  bool? loadingByUser = false;
  bool? get getloadingUser => loadingByUser;
  Future<void> getbyUser() async {
    listpromotionByUser = [];
    loadingByUser = true;
    Response response = await promotionRepo.getbyuser();
    if (response.statusCode == 200) {
      var data = response.body;
      List<PromotionData> listvoucher = [];
      listvoucher.addAll(Promotionmodel.fromJson(data).getlistpromotion ?? []);
      for (PromotionData item in listvoucher) {
        if(!isDateBeforeToday(item.endDate!)){
          listpromotionByUser.add(item);
        }
      }
    } else {
      print("Lỗi lấy khuyến mãi ${response.statusCode}");
    }
    loadingByUser = false;
    update();
  }

 List<PromotionData> getbyuser() {
    List<PromotionData> result = [];
    for (PromotionData item in listpromotionByUser) {
      if ( !isDateBeforeToday(item.endDate!) && isDateBeforeToday(item.startDate!) && item.used! == false) {
        result.add(item);
      }
    }
    return result;
  }


  List<PromotionData> getbystoreidanduser(int storeId) {
    List<PromotionData> result = [];
    for (PromotionData item in listpromotionByUser) {
      if (item.storeId!.contains(storeId) && !isDateBeforeToday(item.endDate!) && isDateBeforeToday(item.startDate!) && item.used! == false) {
        result.add(item);
      }
    }
    return result;
  }

  bool checkVoucher(String code) {
    for (PromotionData item in listpromotionByUser) {
      if (item.code == code) {
        return false;
      }
    }
    return true;
  }

  void savepromotion(int voucherId) async {
    Response response = await promotionRepo.savepromotion(voucherId);
    if (response.statusCode == 200) {
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
      getall();
      getbyUser();
    } else {
      Get.snackbar(
        "Thông báo",
        "Lưu mã giảm giá thất bại",
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
  }
}
