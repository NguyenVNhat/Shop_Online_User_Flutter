import 'package:flutter_user_github/data/repository/Promotion_repo.dart';
import 'package:flutter_user_github/models/Model/PromotionModel.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PromotionController extends GetxController {
  final PromotionRepo promotionRepo;
  PromotionController({
    required this.promotionRepo,
  });

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
  bool? loadingByStoreId;
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
 
}
