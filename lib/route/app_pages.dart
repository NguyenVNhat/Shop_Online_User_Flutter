
import 'package:flutter_user_github/pages/login_page/login_page.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:get/get.dart';

class AppPages {
  static var list = [
    GetPage(name: AppRoute.LOGIN_PAGE, page: () => LoginPage()),
    
  ];
}
