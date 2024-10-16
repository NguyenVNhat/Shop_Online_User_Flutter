import 'package:flutter_user_github/data/repository/Category_repo.dart';
import 'package:flutter_user_github/models/Model/CategoryModel.dart';
import 'package:flutter_user_github/models/Model/Item/CategoryItem.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final CategoryRepo categoryRepo;
  CategoryController({
    required this.categoryRepo,
  });

  // **************************************************************************** Khai báo biến

  // * load dữ liệu danh mục
  bool? _isLoading;
  bool? get isLoading => _isLoading;

  // * load dữ liệu danh mục trong cửa hàng
  bool _isLoadingStore = false;
  bool get isLoadingStore => _isLoadingStore;

  // * danh sách danh mục sản phẩm
  List<Categoryitem> _categoryList = [];
  List<Categoryitem> get categoryList => _categoryList;

  // * danh sách danh mục trong một cửa hàng
  List<Categoryitem> _categoryListStoreId = [];
  List<Categoryitem> get categoryListStoreId => _categoryListStoreId;

  // * Hết khai báo biến ------------------------------------------------------------------------


  // **************************************************************************** Khai báo hàm

  // * Hàm lấy danh sách danh mục
  Future<void> getall() async {
    _isLoading = true;
    Response response = await categoryRepo.getall();
    if (response.statusCode == 200) {
      var data = response.body;
      _categoryList = [];
      _categoryList.addAll(Categorymodel.fromJson(data).get_listCategory ?? []);
    } else {
      _categoryList = [];
    }
    _isLoading = false;
    update();
  }

  // * Hàm lấy danh mục của cửa hàng
  Future<void> getbystoreid(int id) async {
    _isLoadingStore = true;
    Response response = await categoryRepo.getbystoreid(id);

    if (response.statusCode == 200) {
      var data = response.body;
      _categoryListStoreId = [];
      _categoryListStoreId.addAll(Categorymodel.fromJson(data).get_listCategory ?? []);
    } else {
      _categoryListStoreId = [];
    }
    _isLoadingStore = false;
    update();
  }
  
}
