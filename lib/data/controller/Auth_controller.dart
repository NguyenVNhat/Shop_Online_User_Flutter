import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/repository/Auth_repo.dart';
import 'package:flutter_user_github/models/Dto/UserDto.dart';
import 'package:flutter_user_github/models/Dto/UserRegisterDto.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:get/get.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  var IsLogin = false.obs;
  AuthController({
    required this.authRepo,
  });

  // **************************************************************************** Khai báo biến

  // * load dữ liệu
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //* load dữ liệu gửi otp
  bool _IsLoadingSendOtp = false;
  bool get getIsLoadingSendOtp => _IsLoadingSendOtp;
  
  // * id người dùng
  int iduser = 0;
  int get getiduser => iduser;

  // * thông báo khi đăng nhập
  String validateLogin = "";
  String get getvalidateLogin => validateLogin;

  // * thông báo khi đăng kí
  String validateRegister = "";
  String get getvalidateRegister => validateRegister;

  // * thông báo khi gửi otp
  String validatesendotp = "";
  String get getvalidatesendotp => validatesendotp;

  // * api client
  ApiClient apiClient = Get.find<ApiClient>();

  // Hết khai báo biến ------------------------------------------------------------------------


  // **************************************************************************** Khai báo hàm

  // * Hàm đăng nhập
  Future<bool> login(Userdto dto) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(dto);
    if (response.statusCode == 200) {
      var data = response.body["data"];
          iduser = data["id"];

      String newToken = data["token"]; 
          authRepo.saveUserToken(newToken);
          apiClient.updateHeader(newToken);

      IsLogin.value = true;

      update();
      return true;
    } else {

      IsLogin.value = false;
      validateLogin = response.body["message"];

      update();
      return false;
    }
  }

  // * Hàm đăng kí
  Future<bool> register(Userregisterdto dto) async {

    Response response = await authRepo.register(dto);

    if (response.statusCode == 200) {
      return true;
    } else {
      validateRegister = response.body["message"];

      update();
      return false;
    }
  }

  // * Hàm đăng xuất
  Future<bool> logout() async {

    String token = apiClient.gettoken;
    Response response = await authRepo.logout(token);

    if (response.statusCode == 200) {
      IsLogin.value = false;
      Get.toNamed(AppRoute.LOGIN_PAGE);
      update();

      return true;
    } else {
      return false;
    }
  }

  // * Hàm gửi mã otp
  Future<bool> sendotp(String email) async {
    _IsLoadingSendOtp = true;
    Response response = await authRepo.sendotp(email);
    if (response.statusCode == 200) {
      _IsLoadingSendOtp = false;
      update();
      return true;
    } else {
      validatesendotp = response.body["message"];
      _IsLoadingSendOtp = false;
      update();
      return false;
    }
  }

  // * Hàm xác nhận mã otp
   Future<bool> verifyotp(String email,String otp,String password ) async {
    Response response = await authRepo.verifyotp(email,otp,password);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Hết khai báo hàm ------------------------------------------------------------------------
}
