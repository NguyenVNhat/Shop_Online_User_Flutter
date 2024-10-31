import 'dart:convert';

import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/data/repository/Product_repo.dart';
import 'package:flutter_user_github/models/Dto/AddCartDto.dart';
import 'package:flutter_user_github/models/Dto/CommentDto.dart';
import 'package:flutter_user_github/models/Dto/OrderProductDto.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/MomoModel.dart';
import 'package:flutter_user_github/models/Model/ProductModel.dart';
import 'package:flutter_user_github/models/Model/RateModel.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/models/Model/ZaloModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ProductController extends GetxController {
  final ProductRepo productRepo;
  UserController userController = Get.find<UserController>();
  AuthController authController = Get.find<AuthController>();
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
      Get.snackbar(
        "Thông báo",
        "Thêm vào giỏ hàng thành công",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: Icon(Icons.card_giftcard_sharp, color: Colors.green),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 1),
        isDismissible: true,
      );
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
    update();
  }

  Future<List<Productitem>> getProductByStoreCategoryIdV2(
      int storeid, int categoryid) async {
    List<Productitem> list = [];
    Response response =
        await productRepo.getbystoreandcategoryid(storeid, categoryid);
    if (response.statusCode == 200) {
      var data = response.body;

      list.addAll(Productmodel.fromJson(data).get_listproduct ?? []);
    } else {
      print("Lỗi không lấy được danh sách sản phẩm theo danh mục" +
          response.statusCode.toString());
    }
    return list;
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
  void search() {
    try {
      _productListSearch = [];

      if (textSearch.isEmpty) {
        _productListSearch = _productList;
      } else {
        for (Productitem item in _productList) {
          if (item.productName!
              .toLowerCase()
              .contains(textSearch.toLowerCase())) {
            _productListSearch.add(item);
          }
        }
      }
    } catch (e) {
      print("Exception: $e");
      _productListSearch = [];
    } finally {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        update();
      });
    }
  }

  void swap(List<Productitem> arr, int i, int j) {
    Productitem temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }

  int partition(List<Productitem> arr, int low, int high, type) {
    Productitem pivot = arr[high];
    int i = low - 1;

    for (int j = low; j <= high - 1; j++) {
      if (type == 1) {
        if (arr[j].price! > pivot.price!) {
          i++;
          swap(arr, i, j);
        }
      } else {
        if (arr[j].price! < pivot.price!) {
          i++;
          swap(arr, i, j);
        }
      }
    }

    swap(arr, i + 1, high);
    return i + 1;
  }

  void quickSort(List<Productitem> arr, int low, int high, int type) {
    if (low < high) {
      int pi = partition(arr, low, high, type);
      quickSort(arr, low, pi - 1, type);
      quickSort(arr, pi + 1, high, type);
    }
  }

  void sortDes(int type) {
    try {
      quickSort(_productListSearch, 0, _productListSearch.length - 1, type);
    } catch (e) {
      print("Exception: $e");
      _productListSearch = [];
    } finally {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        update();
      });
    }
  }

  void getallProductSearch() {
    try {
      _productListSearch = _productList;
      textSearch = "";
    } catch (e) {
      print("Exception: $e");
      _productListSearch = [];
    } finally {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        update();
      });
    }
  }

  void filterProduct(String categoryName, int lowprice, int highprice) {
    try {
      _productListSearch = [];
      for (Productitem item in productList) {
        if (categoryName == "Tất cả") {
          if (item.price!.toInt() > lowprice &&
              item.price!.toInt() < highprice) {
            _productListSearch.add(item);
          }
        } else {
          if (item.category!.categoryName == categoryName &&
              item.price!.toInt() > lowprice &&
              item.price!.toInt() < highprice) {
            _productListSearch.add(item);
          }
        }
      }
    } catch (e) {
      print("Exception: $e");
      _productListSearch = [];
    } finally {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        update();
      });
    }
  }

  Future<void> searchByImage(String base64Image) async {
    Response response = await productRepo.searchbyimage(base64Image);
    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
      _productListSearch = [];
      for (Productitem item in _productList) {
        if (item.productName!.toLowerCase().contains(data.toLowerCase())) {
          _productListSearch.add(item);
        }
      }
      update();
    } else {
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
    var response = await productRepo.addComment(dto);
    print(response);

    // Chuyển đổi stream thành chuỗi để xử lý
    var responseString = await response.stream.bytesToString();

    try {
      // Giải mã JSON trực tiếp từ chuỗi phản hồi
      var jsonResponse = jsonDecode(responseString);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Thông báo",
          "Phản hồi thành công",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: Icon(Icons.card_giftcard_sharp, color: Colors.green),
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 1),
          isDismissible: true,
        );
        print("oke");
      } else {
        print("Phản hồi thất bại ${response.statusCode}");
        print("Nội dung lỗi: ${jsonResponse['message']}");
      }
    } catch (e) {
      print("Lỗi khi giải mã JSON: $e");
      print("Nội dung không hợp lệ: $responseString");
    }
  }

  List<DisplayRate> listcomment = [];
  List<DisplayRate> get getlistcomment => listcomment;
  bool? loadingComment = false;
  bool? get getloadingComment => loadingComment;
  Future<void> getcomment(int productid) async {
    loadingComment = true;
    Response response = await productRepo.getcomment(productid);
    if (response.statusCode == 200) {
      var data = response.body;
      listcomment = [];
      for (RateData item in Ratemodel.fromJson(data).getlistrate ?? []) {
        User? user = await userController.getbyid(item.userId!);
        while (userController.getloadreceiver!) {
          await Future.delayed(Duration(microseconds: 100));
        }
        DisplayRate displayRate = DisplayRate(user: user, rateData: item);
        listcomment.add(displayRate);
      }
    } else {
      print("Lỗi không nhận được phản hồi ${response.statusCode}");
    }
    loadingComment = false;
    update();
  }

  MomoModels _qrcode = MomoModels();
  MomoModels get qrcode => _qrcode;
  ZaloData _qrcodeZalo = ZaloData();
  ZaloData get qrcodeZalo => _qrcodeZalo;
  bool loadingOrder = false;
  bool get getloadingOrder => loadingOrder;
  Future<void> order(Orderproductdto dto) async {
    loadingOrder = true;
    Response response = await productRepo.order(dto);
    if (response.statusCode == 200) {
      var data = response.body;
      if (dto.paymentMethod == "CASH") {
        Get.snackbar(
          "Thông báo",
          "Đặt đơn hàng thành công",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: Icon(Icons.card_giftcard_sharp, color: Colors.green),
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 1),
          isDismissible: true,
        );
        Get.find<UserController>().addannouce(
            "Thông báo đơn hàng", "Bạn vừa đặt thành công một đơn hàng !");
      } else if (dto.paymentMethod == "MOMO") {
        _qrcode = (MomoModels.fromJson(data).momo);
        print("PAYURRL ${_qrcode.payUrl}");
      } else {
        _qrcodeZalo = ZaloModels.fromJson(data).getzalodata!;
        print("ZALOURL ${_qrcode.payUrl}");
      }
    } else {
      print("Lỗi đặt hàng ${response.statusCode} ${response.body["message"]}");
    }
    loadingOrder = false;
    update();
  }

  Future<List<Productitem>> getbystoreId(int storeid) async {
    List<Productitem> result = [];
    Response response = await productRepo.getbystoreId(storeid);
    if (response.statusCode == 200) {
      var data = response.body;
      result.addAll(Productmodel.fromJson(data).get_listproduct ?? []);
      return result;
    } else {
      print("Lỗi không lấy được sản phẩm");
      return result;
    }
  }

  bool loadingRecommendProduct = false;
  bool get getloadingRecommendProduct => loadingRecommendProduct;
  List<int> listProductId = [];
  Future<void> getRecommendProduct() async {
    loadingRecommendProduct = true;
    Response response =
        await productRepo.getRecommendProduct(authController.getiduser);
    if (response.statusCode == 200) {
      listProductId = [];
      if (response.body is List) {
        listProductId = List<int>.from(response.body);
      } else if (response.body is String) {
        listProductId = List<int>.from(jsonDecode(response.body));
      } else {
        throw Exception("response.body không phải là kiểu hợp lệ");
      }
    } else {
      print("Lỗi không lấy được danh sách sản phẩm hay mua");
    }
    loadingRecommendProduct = false;
    update();
  }

  List<Productitem> listProductRecommend = [];
  List<Productitem> get getlistProductRecommend => listProductRecommend;
  void GetProductRecommend() async {
    for (Productitem item in _productList) {
      if (listProductId.contains(item.productId)) {
        listProductRecommend.add(item);
      }
    }
  }

  bool loadDrinkInCombo = false;
  bool get getloadDrinkInCombo => loadDrinkInCombo;
  Future<List<Productitem>?> getListDrinkInCombo(List<int> storeId) async {
    loadDrinkInCombo = true;
    List<Productitem> res = [];
    Response response = await productRepo.getListDrinkInCombo(storeId);
    if (response.statusCode == 200) {
      res = [];
      var data = response.body;
      res.addAll(Productmodel.fromJson(data).get_listproduct ?? []);
      loadDrinkInCombo = false;
      update();
      return res;
    }
    else{
      print("Không lấy được danh sách nước uống ${response.statusCode} ${response.body}");
    }
    
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