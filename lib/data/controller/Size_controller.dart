import 'package:flutter_user_github/data/repository/Size_repo.dart';
import 'package:flutter_user_github/models/Model/SizeModel.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SizeController extends GetxController {
  final SizeRepo sizeRepo;
  SizeController({
    required this.sizeRepo,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Size> _sizelist = [];
  List<Size> get sizelist => _sizelist;

  Future<void> getall() async {
    _isLoading = true;
    Response response = await sizeRepo.getall();
    if (response.statusCode == 200) {
      print("Lấy dữ liệu danh sách size thành công");
      var data = response.body;
      _sizelist = [];
      _sizelist.addAll(Sizemodel.fromJson(data).listsize ?? []);
    } else {
      print("Lỗi không lấy được dữ liệu size : " +
          response.statusCode.toString());
    }
    _isLoading = false;
    update();
  }

  String sizename = "";
  String get getsizename => sizename;
  Future<void> getbyidl(int id) async {
    _isLoading = true;
    Response response = await sizeRepo.getbyid(id);
    if (response.statusCode == 200) {
      print("Lấy dữ liệu size by id thành công");
      var data = response.body["data"];
      sizename = data["name"];
    } else {
      print("Lỗi không lấy được dữ liệu size : " +
          response.statusCode.toString());
    }
    _isLoading = false;
    update();
  }
}
