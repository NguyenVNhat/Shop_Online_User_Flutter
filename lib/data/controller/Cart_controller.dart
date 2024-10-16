import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/data/repository/Cart_repo.dart';
import 'package:flutter_user_github/models/Dto/CartDto.dart';
import 'package:flutter_user_github/models/Model/CartModel.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/MomoModel.dart';
import 'package:flutter_user_github/models/Model/NewCartModel.dart';
import 'package:get/get.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({
    required this.cartRepo,
  });
  // **************************************************************************** Khai báo biến

  // * load dữ liệu giỏ hàng
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // * mã QR thanh toán
  MomoModels _qrcode = MomoModels();
  MomoModels get qrcode => _qrcode;

  // * danh sách sản phẩm trong giỏ hàng
  List<CartData> _cartlist = [];
  List<CartData> get cartlist => _cartlist;

  // * tổng giá của giỏ hàng
  int _totalprice = 0;
  int get totalprice => _totalprice;
  

  // * danh sách các sản phẩm được chọn để thanh toán
  List<int> _IDSelectedItem = [];
  List<int> get IDSelectedItem => _IDSelectedItem;

  // * danh sách các cửa hàng được chọn để thanh toán
  List<int> _IDSelectedStore = [];
  List<int> get IDSelectedStore => _IDSelectedStore;

  // * danh sách các combo được chọn để thanh toán
  List<int> _IDSelectedCombo = [];
  List<int> get IDSelectedCombo => _IDSelectedCombo;

  // *  danh sách các cửa hàng 
  List<int> listIDStore = [];
  List<int> get getlistIDStore => listIDStore;

  // * danh sách các sản phẩm của cửa hàng
  List<ProductInCart> listCartWithStoreId = [];
  List<ProductInCart> get getlistCartWithStoreId => listCartWithStoreId;

  // * danh sách các sản phẩm 
  List<Newcartmodel> listcart = [];
  List<Newcartmodel> get getlistcart => listcart;

  // * danh sách sản phẩm chọn để thanh toán
  List<Newcartmodel> listcartinorder = [];
  List<Newcartmodel> get getlistcartinorder => listcartinorder;

  // * Controller 
  Storecontroller storecontroller = Get.find<Storecontroller>();
  // Hết khai báo biến ------------------------------------------------------------------------


  // **************************************************************************** Khai báo hàm

  // * Hàm lấy danh sách sản phẩm trong giỏ hàng
  Future<void> getall() async {

    _isLoading = true;
    Response response = await cartRepo.getall();

    if (response.statusCode == 200) {
      var data = response.body;
      _cartlist = [];
      var cartData = Cartmodel.fromJson(data).getdata;
      if (cartData != null) {
        _cartlist.addAll(cartData);
      }
      _totalprice = _cartlist
          .where((item) => item.product != null)
          .map((item) => item.product!.totalPrice ?? 0.0)
          .fold(0, (previous, current) => previous.toInt() + current.toInt());
      _totalprice = _totalprice.toInt();
    } else {
      _cartlist = [];
      _totalprice = 0;
    }

    _isLoading = false;
    update();
  }
  bool? ordering = false;
  bool? get getordering => ordering;

  // * Hàm thanh toán đơn hàng
  Future<void> orderall(String address, String paymentMethod) async {
    ordering = true;
    // * Thanh toán các đơn nằm được chọn 
    if (!listcartinorder.isEmpty) {
      List<int> listIdCartItem = [];
      for(Newcartmodel cartmodel in listcartinorder){
        for(CartData cart in cartmodel.cartdata!){
          listIdCartItem.add(cart.cartId!);
        }
      }

      Response response = await cartRepo.orderproductintcart(Cartdto(
          cartlist: listIdCartItem,
          deliveryAddress: address,
          paymentMethod: paymentMethod));
      if (response.statusCode == 200) {
        if (paymentMethod == "CASH") {
          Get.snackbar("Thông báo", "Đặt đơn hàng thành công");
          Get.find<UserController>().addannouce("Thông báo đơn hàng", "Bạn vừa đặt thành công một đơn hàng !"); 
          await getListCartV2();
        } else {
          var data = response.body;
          _qrcode = (MomoModels.fromJson(data).momo);
          print( "PAYURRL ${_qrcode.payUrl}");
        }
      } else {
        print("Đặt đơn hàng sản phẩm thất bại : " +response.statusCode.toString());
      }
    }
     else {
      Get.snackbar("Thông báo", "Vui lòng chọn sản phẩm đặt đơn");
    }
    ordering = false;
    update();
  }

  // * Hàm cập nhật tổng tiền giỏ hàng
  void updateTotal(double newtotal) {
    this._totalprice = newtotal.toInt();
    update();
  }

  // * Hàm reset chỉ số khi chuyển trang khác
  void resetIDSelected() {
    _IDSelectedItem.clear();
    _IDSelectedCombo.clear();
    _IDSelectedStore.clear();
    update();
  }

  // * Hàm cập nhật các cửa hàng được chọn
  void updateIDSelectedStore(int id, bool value) {
    if (value) {
      _IDSelectedStore.add(id);
    } else {
      _IDSelectedStore.remove(id);
    }
    update();
  }

  // * Hàm cập nhật các sản phẩm được chọn
  void updateIDSelectedItem(int id, bool value) {
    if (value) {
      _IDSelectedItem.add(id);
    } else {
      _IDSelectedItem.remove(id);
    }
    update();
  }

 

  bool checkInList(int storeId, List<int> listId) {
    for (int item in listId) {
      if (item == storeId) {
        return false;
      }
    }
    return true;
  }

  
  // * Hàm lấy ra các cửa hàng của sản phẩm
  void getDistinctStoreId() async {
    _cartlist.forEach((item) {
      if(item.type == "product"){
        if (checkInList(item.product!.storeId!, listIDStore)) {
          listIDStore.add(item.product!.storeId!);
        };
      }
      else{
        if (checkInList(item.combo!.storeId!, listIDStore)) {
          listIDStore.add(item.combo!.storeId!);
        };
      }
    });
  }

  // * Hàm lấy ra các sản phẩm của cửa hàng 
  void getCartWithStoreId(int storeId) {
    _cartlist.forEach((item) {
      if (item.product!.storeId == storeId) {
        listCartWithStoreId.add(item.product!);
      }
    });
  }

  // * Hàm lấy các sản phẩm trong giở hàng
  Future<void> getListCartV2() async {
    listcart = [];
    List<int> liststoreid = [];
    Response response = await cartRepo.getallstoreincart();
    if (response.statusCode == 200) {
      try {
        var data = response.body;
        if (data["data"] is List) {
          liststoreid.addAll(List<int>.from(data["data"]));
        } else {
          print("data['data'] is not a List: ${data["data"]}");
          liststoreid = [];
          listcart = [];
          update();
        }
      } catch (e) {
        print("An error occurred: $e");
        liststoreid = [];
        listcart = [];
      }

      for (int storeid in liststoreid) {
        await storecontroller.getbyid(storeid);
        Storesitem item = storecontroller.storeItem!;

        List<CartData> cartmodellist = [];
        Response responsev2 = await cartRepo.getlistcartbystore(storeid);
        if (responsev2.statusCode == 200) {
          var dataproduct = responsev2.body;
          cartmodellist.addAll(Cartmodel.fromJson(dataproduct).getdata ?? []);
          print("Lấy danh sách giở hàng mới thành công");
        } else {
          listcart = [];
          print("Không có sản phẩm");
          return;
        }
        Newcartmodel newcartmodel =
            Newcartmodel(storeitem: item, cartdata: cartmodellist);
        listcart.add(newcartmodel);

        update();
      }
    } else {
      print("Không có cửa hàng");
    }
  }

  // * Hàm lấy các sản phẩm trong được thanh toán
  Future<void> getlistcartorder() async {
    listcartinorder.clear();
    if (_IDSelectedStore.isNotEmpty) {
      for (int storeid in _IDSelectedStore) {
        await storecontroller.getbyid(storeid);
        Storesitem item = storecontroller.storeItem!;

        Response responsev2 = await cartRepo.getlistcartbystore(storeid);
        if (responsev2.statusCode == 200) {
          var dataproduct = responsev2.body;
          List<CartData> cartmodellist =
              Cartmodel.fromJson(dataproduct).getdata ?? [];

          Newcartmodel newcartmodel =
              Newcartmodel(storeitem: item, cartdata: cartmodellist);
          listcartinorder.add(newcartmodel);

          cartmodellist.forEach((idcart) {
            _IDSelectedItem.remove(idcart.cartId);
          });
          print("Lấy danh sách giỏ hàng mới thành công");
        } else {
          print("Không có sản phẩm");
          return;
        }
        update();
      }
    }

    if (_IDSelectedItem.isNotEmpty) {
      print("Product ${_IDSelectedItem}");
      for (int productId in _IDSelectedItem) {
        Response response = await cartRepo.getbyid(productId);
        if (response.statusCode == 200) {
          var data = response.body;
          print(data);
          CartData cartData = CartData.fromJson(data["data"][0]);
          bool newitem = true;
          for (Newcartmodel cart in listcartinorder) {
            if (cart.storeitem!.storeId == cartData.product!.storeId) {
              Set<int> cartIdSet = cart.cartdata!.map((e) => e.cartId!).toSet();
              if (!cartIdSet.contains(cartData.cartId)) {
                cart.cartdata!.add(cartData);
                newitem = false;
                update();
              } else {
                newitem = false;
              }
            }
          }
          if (newitem) {
            await storecontroller.getbyid(cartData.product!.storeId!);
            Storesitem storeitem = storecontroller.storeItem!;

            Newcartmodel newcartmodel =
                Newcartmodel(storeitem: storeitem, cartdata: [cartData]);
            listcartinorder.add(newcartmodel);
            update();
          }
        }
      }
    }
  }
}
