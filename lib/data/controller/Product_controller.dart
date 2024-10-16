import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/data/repository/Product_repo.dart';
import 'package:flutter_user_github/models/Dto/AddCartDto.dart';
import 'package:flutter_user_github/models/Dto/CartDto.dart';
import 'package:flutter_user_github/models/Dto/CommentDto.dart';
import 'package:flutter_user_github/models/Dto/OrderProductDto.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/MomoModel.dart';
import 'package:flutter_user_github/models/Model/ProductModel.dart';
import 'package:flutter_user_github/models/Model/RateModel.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final ProductRepo productRepo;
  ProductController({
    required this.productRepo,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lấy tất cả sản phẩm
  List<Productitem> _productList = [];
  List<Productitem> get productList => _productList;

  Future<void> getall() async {
    _isLoading = true;
    Response response = await productRepo.getall();
    if (response.statusCode == 200) {
      var data = response.body;
      _productList = [];
      _productList.addAll(Productmodel.fromJson(data).get_listproduct ?? []);
    } else {
      print("Lỗi không lấy được dữ liệu danh sách sản phẩm : " +
          response.statusCode.toString());
    }
    _isLoading = false;
    update();
  }

  // Lấy sản phẩm theo id
  Productitem? getproductbyid(int id) {
    for (Productitem item in _productList) {
      if (item.productId == id) {
        return item;
      }
    }
    return null;
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addtocart(
      int productid, int quantity, int idstore, String sizename) async {
    _isLoading = true;
    AddcartDto cart = AddcartDto(
        productId: productid,
        quantity: quantity,
        size: sizename,
        storeId: idstore);
    Response response = await productRepo.addtocart(cart);
    if (response.statusCode == 200) {
      Get.snackbar("Thông báo", "Thêm vào giỏ hàng thành công");
      Get.find<UserController>().addannouce(
          "Thông báo giỏ hàng", "Bạn vừa thêm một sản phẩm vào giỏ hàng !");
    } else {
      print("Lỗi thêm sản phẩm vào giỏ hàng" + response.statusCode.toString());
    }
    _isLoading = false;
    update();
  }

  // Lấy sản phẩm theo danh mục
  List<Productitem> _productListBycategory = [];
  List<Productitem> get productListBycategory => _productListBycategory;
  bool? _isLoadingProductIncategory;
  bool? get isLoadingProductIncategory => _isLoadingProductIncategory;
  Future<void> getProductByCategoryId(int id) async {
    _isLoadingProductIncategory = true;
    Response response = await productRepo.getbycategoryid(id);
    if (response.statusCode == 200) {
      var data = response.body;
      _productListBycategory = [];
      _productListBycategory
          .addAll(Productmodel.fromJson(data).get_listproduct ?? []);
    } else {
      print("Lỗi không lấy được danh sách sản phẩm theo danh mục" +
          response.statusCode.toString());
    }
    _isLoadingProductIncategory = false;
    update();
  }

  // Lấy tất cả sản phẩm của cửa hàng theo danh mục
  List<Productitem> _productListBycategorystore = [];
  List<Productitem> get productListBycategorystore =>
      _productListBycategorystore;

  bool _isLoadingStoreCategory = false;
  bool get isLoadingStoreCategory => _isLoadingStoreCategory;
  Future<void> getProductByStoreCategoryId(int storeid, int categoryid) async {
    _isLoadingStoreCategory = true;
    print(_isLoadingStoreCategory);
    Response response =
        await productRepo.getbystoreandcategoryid(storeid, categoryid);
    if (response.statusCode == 200) {
      var data = response.body;
      _productListBycategorystore = [];
      _productListBycategorystore
          .addAll(Productmodel.fromJson(data).get_listproduct ?? []);
      print("Lấy danh sách sản phẩm theo danh mục và cửa hàng thành công");
    } else {
      print("Lỗi không lấy được danh sách sản phẩm theo danh mục" +
          response.statusCode.toString());
    }
    _isLoadingStoreCategory = false;
    print(_isLoadingStoreCategory);
    update();
  }

  String textSearch = "";
  String get gettextSearch => textSearch;

  void updateTextSearch(String text) {
    this.textSearch = text;
    update();
  }

  // Tìm kiếm sản phẩm theo tên
  List<Productitem> _productListSearch = [];
  List<Productitem> get productListSearch => _productListSearch;

  // Future<void> search() async {
  //   try {
  //     if (textSearch == "") {
  //       _productListSearch = _productList;
  //     } else {
  //       Response response = await productRepo.getbyname(this.textSearch);
  //       print(textSearch);
  //       if (response.statusCode == 200) {
  //         var data = response.body;
  //         _productListSearch = [];
  //         _productListSearch
  //             .addAll(Productmodel.fromJson(data).get_listproduct ?? []);

  //       } else {
  //         print("Lỗi không lấy được danh sách sản phẩm theo tên" +
  //             response.statusCode.toString());
  //         _productListSearch = [];
  //       }
  //     }
  //   } catch (e) {
  //     print("Exception: $e");
  //     _productListSearch = [];
  //   } finally {
  //     SchedulerBinding.instance.addPostFrameCallback((_) {
  //       update();
  //     });
  //   }
  // }
  void search() {
    try {
    _productListSearch = []; 

    if (textSearch.isEmpty) {
      _productListSearch = _productList; 
    } else {
      for (Productitem item in _productList) {
        if (item.productName!.toLowerCase().contains(textSearch.toLowerCase())) {
          _productListSearch.add(item); 
        }
      }
    }
    }
    catch (e) {
      print("Exception: $e");
      _productListSearch = [];
    } finally {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        update();
      });
    }
  }

  Future<void> searchByImage(String base64Image) async{
      Response response = await productRepo.searchbyimage(base64Image);
      if(response.statusCode == 200){
        var data = response.body;
          _productListSearch = [];
          _productListSearch
              .addAll(Productmodel.fromJson(data).get_listproduct ?? []);
          update();
          print("Món ăn" +_productListSearch[0].productName!);
      }else{
        print("Lỗi ${response.statusCode}");
         _productListSearch = [];
         update();
      }
  }

  // Lấy danh sách nước uống
  List<Productitem>? getlistdrink() {
    List<Productitem> _productListDrink = [];
    for (Productitem item in productList) {
      if (item.category!.categoryName == "Nước uống") {
        _productListDrink.add(item);
      }
    }
    return _productList;
  }

  Future<void> addcomment(Commentdto dto) async {
    Response response = await productRepo.addcomment(dto);
    if (response.statusCode == 200) {
      Get.snackbar("Thông báp", "Phản hồi thành công");
    } else {
      print("Phản hồi thất bại");
    }
  }

  List<RateData> listcomment = [];
  List<RateData> get getlistcomment => listcomment;
  bool? loadingComment = false;
  bool? get getloadingComment => loadingComment;
  Future<void> getcomment(int productid) async {
    loadingComment = true;
    Response response = await productRepo.getcomment(productid);
    if (response.statusCode == 200) {
      var data = response.body;
      listcomment = [];
      listcomment.addAll(Ratemodel.fromJson(data).getlistrate ?? []);
    } else {
      print("Lỗi không nhận được phản hồi ${response.statusCode}");
    }
    loadingComment = false;
    update();
  }

  MomoModels _qrcode = MomoModels();
  MomoModels get qrcode => _qrcode;
  bool loadingOrder = false;
  bool get getloadingOrder => loadingOrder;
  Future<void> order(Orderproductdto dto) async {
    loadingOrder = true;
    Response response = await productRepo.order(dto);
    if (response.statusCode == 200) {
      if (dto.paymentMethod == "CASH") {
        Get.snackbar("Thông báo", "Đặt đơn hàng thành công");
        Get.find<UserController>().addannouce(
            "Thông báo đơn hàng", "Bạn vừa đặt thành công một đơn hàng !");
      } else {
        var data = response.body;
        _qrcode = (MomoModels.fromJson(data).momo);
        print("PAYURRL ${_qrcode.payUrl}");
      }
    }
    loadingOrder = false;
    update();
  }
}

/*
List<Productitem> _productListDetail = [];
  List<Productitem> get productListDetail => _productListDetail;
  Future<void> getProductById(int id) async {
    _isLoading = true;
    Response response = await productRepo.getbyid(id);
    if (response.statusCode == 200) {
      var data = response.body;
      _productListDetail = [];
      _productListDetail
          .addAll(Productmodel.fromJson(data).get_listproduct ?? []);
    } else {
      print("Lỗi không lấy được dữ liệu chi tiết sản phẩm : " +
          response.statusCode.toString());
    }
    _isLoading = false;
    update();
  }
*/