import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/data/repository/Order_repo.dart';
import 'package:flutter_user_github/models/Model/OrderModel.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderRepo orderRepo;
  OrderController({
    required this.orderRepo,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;



  List<OrderItem> _orderlist = [];
  List<OrderItem> get orderlist => _orderlist;

  Future<void> getall() async {
    _isLoading = true;
    Response response = await orderRepo.getall();
    if (response.statusCode == 200) {
      print("Lấy thành công danh sách đơn hàng");
      var data = response.body;
      _orderlist = Ordermodel.fromJson(data).getorderitem ?? [];
    } else {
      print("Lỗi không lấy được danh sách đơn hàng: " +
          response.statusCode.toString());
      _orderlist = [];
    }
    _isLoading = false;
    update();
  }

  OrderItem? _orderdetail;
  OrderItem? get orderdetail => _orderdetail;

  Future<void> getorderbyOrdercode(String ordercode) async {
    _isLoading = true;
    Response response = await orderRepo.getorderbyordercode(ordercode);
    if (response.statusCode == 200) {
      print("Lấy thành công chi tiết đơn hàng");
      var data = response.body;

      _orderdetail = OrderItem.fromJson(data["data"]);
    } else {
      print("Lỗi không lấy được danh sách đơn hàng: " +
          response.statusCode.toString());
    }
    _isLoading = false;
    update();
  }

  Future<void> getorderWithStatus(String status) async {
    _isLoading = true;
    Response response = await orderRepo.getorderbyorderstatus(status);
    if (response.statusCode == 200) {
      print("Lấy thành công danh sách đơn hàng");
      var data = response.body;
      _orderlist = Ordermodel.fromJson(data).getorderitem ?? [];
    } else {
      print("Lỗi không lấy được danh sách đơn hàng: " +
          response.statusCode.toString());
      _orderlist = [];
    }
    _isLoading = false;
    update();
  }
  Future<void> updatefeedback(int orderid)async{
    Response response = await orderRepo.updatefeedback(orderid);
    if(response.statusCode != 200){
      print("Lỗi feedback");
    }
  }
  Future<void> cancelorder(String ordercode)async{
    Response response = await orderRepo.cancelorder(ordercode);
    if(response.statusCode != 200){
      print("Lỗi hủy đơn");
    }
    else{
      Get.find<UserController>().addannouce("Thông báo đơn hàng", "Bạn vừa đặt hủy thành công một đơn hàng !"); 
     
      
    }
  }
}
