import 'package:flutter_user_github/pages/forget_password_page/forget_password_page.dart';
import 'package:flutter_user_github/pages/home_page/home_page.dart';
import 'package:flutter_user_github/pages/login_page/login_page.dart';
import 'package:flutter_user_github/pages/register_page/register_page.dart';
import 'package:flutter_user_github/pages/search_page/search_page.dart';
import 'package:flutter_user_github/pages/store_page/store_page.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:get/get.dart';

class AppPages {
  static var list = [
    GetPage(name: AppRoute.LOGIN_PAGE, page: () => LoginPage()),
    GetPage(name: AppRoute.REGISTER_PAGE, page: () => RegisterPage()),
    GetPage(
        name: AppRoute.FORGET_PASSWORD_PAGE, page: () => ForgetPasswordPage()),
    GetPage(name: AppRoute.HOME_PAGE, page: () => HomePage()),
    GetPage(name: AppRoute.SEARCH_PAGE, page: () => SearchPage()),
    GetPage(name: AppRoute.STORE_PAGE, page: () => StorePage()),
  ];
}
