import 'package:flutter_user_github/data/repository/Store_repo.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/StoreModel.dart';
import 'package:get/get.dart';

class Storecontroller extends GetxController {
  final StoreRepo storeRepo;
  Storecontroller({
    required this.storeRepo,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Storesitem> _storeList = [];
  List<Storesitem> get storeList => _storeList;

  Future<void> getall() async {
    _isLoading = true;
    Response response = await storeRepo.getall();

    if (response.statusCode == 200) {
      print("Lấy dữ liệu danh sách cửa hàng thành công");
      var data = response.body;
      _storeList = [];
      _storeList.addAll(Storesmodel.fromJson(data).get_liststores ?? []);
    } else {
      print("Lỗi không lấy được danh sách cửa hàng : " +
          response.statusCode.toString());
    }
    _isLoading = false;
    update();
  }

  String addressOfStore(int storeid) {
    for (Storesitem item in _storeList) {
      if (item.storeId == storeid) {
        return item.location!;
      }
    }
    return "";
  }

  Storesitem? getStoreById(int idstore) {
    for (Storesitem item in _storeList) {
      if (item.storeId == idstore) {
        return item;
      }
    }
  }

  Storesitem? _storeItem;
  Storesitem? get storeItem => _storeItem;
  bool _isLoadingItem = false;
  bool get isLoadingItem => _isLoadingItem;

  Future<void> getbyid(int id) async {
    _isLoadingItem = true;
    Response response = await storeRepo.getbyid(id);
    if (response.statusCode == 200) {
      var data = response.body;
      _storeItem = Storesitem.fromJson(data["data"]);
      print("Lấy chi tiết cửa hàng thành công");
    } else {
      print("Lỗi không lấy được cửa hàng" + response.statusCode.toString());
    }
    _isLoadingItem = false;
    update();
  }

  Future<String> getnamestoreByid(int id) async {
    Response response = await storeRepo.getbyid(id);
    if (response.statusCode == 200) {
      var data = response.body["data"];
      return data["storeName"];
    } else {
      return "No name";
    }
  }
  bool loadingCommonStore = false;
  bool get getloadingCommonStore => loadingCommonStore;

  List<Storesitem> getCommonStores(List<Productitem> listproduct) {
    loadingCommonStore = true;
    if (listproduct.isEmpty) {
      print("Danh sách sản phẩm trống.");
      return [];
    }
    List<Storesitem> initialStores = listproduct[0].stores!;
    Set<String?> commonStoreNames =
        initialStores.map((store) => store.storeName).toSet();
    for (int i = 1; i < listproduct.length; i++) {
      List<Storesitem> currentStores = listproduct[i].stores!;
      Set<String?> currentStoreNames =
          currentStores.map((store) => store.storeName).toSet();
      commonStoreNames = commonStoreNames.intersection(currentStoreNames);
    }
    List<Storesitem> commonStores = [];
    for (var storeName in commonStoreNames) {
      var store =
          initialStores.firstWhere((store) => store.storeName == storeName);
      commonStores.add(store);
    }
    loadingCommonStore = false;
    return commonStores;
  }
}
