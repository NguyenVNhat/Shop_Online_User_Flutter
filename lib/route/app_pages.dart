import 'package:flutter_user_github/pages/cart_page/cart_order/cart_order.dart';
import 'package:flutter_user_github/pages/cart_page/cart_page.dart';
import 'package:flutter_user_github/pages/category_page/category_detail_page/category_detail_page.dart';
import 'package:flutter_user_github/pages/category_page/category_page.dart';
import 'package:flutter_user_github/pages/chat_page/chart_page.dart';
import 'package:flutter_user_github/pages/forget_password_page/forget_password_page.dart';
import 'package:flutter_user_github/pages/home_page/combo/combo_detail.dart';
import 'package:flutter_user_github/pages/home_page/combo/payment_combo.dart';
import 'package:flutter_user_github/pages/home_page/home_page.dart';
import 'package:flutter_user_github/pages/login_page/login_page.dart';
import 'package:flutter_user_github/pages/order_page/order_detail_page.dart';
import 'package:flutter_user_github/pages/order_page/order_page.dart';
import 'package:flutter_user_github/pages/product_page/product_order.dart';
import 'package:flutter_user_github/pages/product_page/product_page.dart';
import 'package:flutter_user_github/pages/profile_page/notification/notification.dart';
import 'package:flutter_user_github/pages/profile_page/profile_page.dart';
import 'package:flutter_user_github/pages/profile_page/profile_setting_page/profile_camera.dart';
import 'package:flutter_user_github/pages/profile_page/profile_setting_page/profile_setting_page.dart';
import 'package:flutter_user_github/pages/profile_page/profile_setup_page/profile_setup_page.dart';
import 'package:flutter_user_github/pages/profile_page/profile_setup_page/shipper_register/shipper_register_page.dart';
import 'package:flutter_user_github/pages/profile_page/transferpoint/transfer_point_page.dart';
import 'package:flutter_user_github/pages/profile_page/promotion_page/promotion_page.dart';
import 'package:flutter_user_github/pages/register_page/register_page.dart';
import 'package:flutter_user_github/pages/search_page/camera_page.dart';
import 'package:flutter_user_github/pages/search_page/search_page.dart';
import 'package:flutter_user_github/pages/store_page/store_detail/store_detail_page.dart';
import 'package:flutter_user_github/pages/store_page/store_page.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:get/get.dart';

class AppPages {
  static var list = [
    GetPage(name: AppRoute.LOGIN_PAGE, page: () => LoginPage()),
    GetPage(name: AppRoute.REGISTER_PAGE, page: () => RegisterPage()),
    GetPage(name: AppRoute.FORGET_PASSWORD_PAGE, page: () => ForgetPasswordPage()),
    GetPage(name: AppRoute.HOME_PAGE, page: () => HomePage()),
    GetPage(name: AppRoute.PROFILE_PAGE, page: () => ProfilePage()),
    GetPage(name: AppRoute.CAMERA_PAGE, page: () => CameraPage()),
    GetPage(name: AppRoute.CART_PAGE, page: () => CartPage()),
      
    GetPage(name: AppRoute.CATEGORY_PAGE, page: () => CategoryPage()),
    GetPage(name: AppRoute.ORDER_PAGE, page: () => OrderPage()),
    GetPage(name: AppRoute.SEARCH_PAGE, page: () => SearchPage()),
    GetPage(name: AppRoute.PROFILE_SETTING_PAGE, page: () => ProfileSettingPage()),
    GetPage(name: AppRoute.PROFILE_CAMERA_PAGE, page: () => ProfileCamera()),
    GetPage(name: AppRoute.PROFILE_SETUP_PAGE, page: () => ProfileSetupPage()),
    GetPage(name: AppRoute.PROMOTION_PAGE, page: () => PromotionPage()),
    GetPage(name: AppRoute.CHART_PAGE, page: () => ChartPage()),
    GetPage(name: AppRoute.REGISTER_SHIP_PAGE, page: () => ShipperRegisterPage()),
    GetPage(name: AppRoute.ORDER_CART_PAGE, page: () => CartOrder()),
    GetPage(name: AppRoute.NOTIFICATION_PAGE, page: () => Notification()),
    GetPage(name: AppRoute.TRANSFER_POINT_PAGE, page: () => TransferPointPage()),
    GetPage(
        name: AppRoute.ORDER_DETAIL_PAGE,
        page: () {
          String orderCode = Get.parameters['orderCode']!;
          return OrderDetailPage(orderCode: orderCode);
        }),
    GetPage(
        name: AppRoute.COMBO_DETAIL,
        page: () {
          var comboId = Get.parameters['comboId'];
          int comboIdInt = int.tryParse(comboId ?? '0') ?? 0;
          return ComboDetail(comboId: comboIdInt);
        },
        transition: Transition.fadeIn),
    GetPage(
        name: AppRoute.PRODUCT_DETAIL,
        page: () {
          var productId = Get.parameters['productId'];
          int productIdInt = int.tryParse(productId ?? '0') ?? 0;
          return ProductPage(productId: productIdInt);
        }),
    GetPage(
        name: AppRoute.CATEGORY_DETAIL_PAGE,
        page: () {
          var categoryid = Get.parameters['categoryid'];
          var categoryname = Get.parameters['categoryname'];
          int categoryidInt = int.tryParse(categoryid ?? '0') ?? 0;
          return CategoryDetailPage(
              categoryid: categoryidInt, categoryname: categoryname!);
        }),
     GetPage(
        name: AppRoute.STORE_DETAIL_PAGE,
        page: () {
          var storeid = Get.parameters['storeid'];
          int storeIdInt = int.tryParse(storeid ?? '0') ?? 0;
          return StoreDetailPage(storeId: storeIdInt);
        }),

      GetPage(
        name: AppRoute.ORDER_COMBO_PAGE,
        page: () {
          var comboId = Get.parameters['comboid'];
          var drinkid = Get.parameters['drinkid'];
          int comboIdInt = int.tryParse(comboId ?? '0') ?? 0;
          int drinkIdInt = int.tryParse(drinkid ?? '0') ?? 0;
          return PaymentCombo(idcombo: comboIdInt,iddrink: drinkIdInt,);
        }),
      GetPage(
        name: AppRoute.ORDER_PRODUCT_PAGE,
        page: () {
          var product = Get.parameters['product'];
          var size = Get.parameters['size'];
          var quantity = Get.parameters['quantity'];

          int productInt = int.tryParse(product ?? '0') ?? 0;
          int quantityInt = int.tryParse(quantity ?? '0') ?? 0;
          return ProductOrder(idproduct: productInt,quantity: quantityInt,size: size!,);
        }),
  ];
}
