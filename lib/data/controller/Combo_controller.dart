import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/data/repository/Combo_repo.dart';
import 'package:flutter_user_github/models/Dto/OrderComboDto.dart';
import 'package:flutter_user_github/models/Model/ComboModel.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Model/MomoModel.dart';
import 'package:get/get.dart';

class ComboController extends GetxController {
  final ComboRepo comboRepo;
  ComboController({
    required this.comboRepo,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Comboitem> _comboList = [];
  List<Comboitem> get comboList => _comboList;


  Future<void> getall() async {
    _isLoading = true;
    Response response = await comboRepo.getall();

    if (response.statusCode == 200) {
      var data = response.body;
      _comboList = [];
      _comboList.addAll(Combomodel.fromJson(data).get_listcombo ?? []);
    } else {
      _comboList = [];
    }
    _isLoading = false;
    update();
  }
  MomoModels _qrcode = MomoModels();
  MomoModels get qrcode => _qrcode;
  Future<void> order(Ordercombodto dto) async{
    Response response = await comboRepo.order(dto);
    if(response.statusCode == 200){
      if (dto.paymentMethod == "CASH") {
          Get.snackbar("Thông báo", "Đặt đơn hàng thành công");
          Get.find<UserController>().addannouce("Thông báo đơn hàng", "Bạn vừa đặt thành công một đơn hàng !"); 
        } else {
          var data = response.body;
          _qrcode = (MomoModels.fromJson(data).momo);
          print( "PAYURRL ${_qrcode.payUrl}");
        }
    }
    else{
      var data = response.body;
      Get.snackbar("Thông báo",data["message"]);
    }
    update();
  }

  Comboitem? getcombobyId(int id){
    for(Comboitem item in _comboList){
      if(item.comboId == id)
        return item;
    }
    return null;
  }
}
/*
  List<Comboitem> _comboDetail = [];
  List<Comboitem> get comboDetail => _comboDetail;
  Future<void> getbyid(int id) async {
    _isLoading = true;
    Response response = await comboRepo.getbyid(id);
    if (response.statusCode == 200) {
      var data = response.body;
      _comboDetail = [];
      _comboDetail.addAll(Combomodel.fromJson(data).get_listcombo ?? []);
      update();
    } else {
      _comboDetail = [];
    }
    _isLoading = false;
    update();
  }
  */