
import 'package:flutter_user_github/page/cart_page/cart_order/cart_order.dart';
import 'package:flutter_user_github/page/cart_page/cart_page.dart';
import 'package:flutter_user_github/page/category_page/category_detail_page/category_detail_page.dart';
import 'package:flutter_user_github/page/category_page/category_page.dart';
import 'package:flutter_user_github/page/chat_page/chart_page.dart';
import 'package:flutter_user_github/page/chat_page/home_chart/home_chat_detail.dart';
import 'package:flutter_user_github/page/chat_page/search_chart/search_chat.dart';
import 'package:flutter_user_github/page/chat_page/store_chat/store_chat.dart';
import 'package:flutter_user_github/page/chat_page/store_chat/store_chat_detail.dart';
import 'package:flutter_user_github/page/forget_password_page/forget_password_page.dart';
import 'package:flutter_user_github/page/home_page/detail_page/combo/combo_detail.dart';
import 'package:flutter_user_github/page/home_page/detail_page/combo/payment_combo.dart';
import 'package:flutter_user_github/page/home_page/home_page.dart';
import 'package:flutter_user_github/page/login_page/login_page.dart';
import 'package:flutter_user_github/page/order_page/order_detail_page.dart';
import 'package:flutter_user_github/page/order_page/order_page.dart';
import 'package:flutter_user_github/page/product_page/product_all.dart';
import 'package:flutter_user_github/page/product_page/product_order.dart';
import 'package:flutter_user_github/page/product_page/product_page.dart';
import 'package:flutter_user_github/page/profile_page/notification/notification.dart';
import 'package:flutter_user_github/page/profile_page/profile_page.dart';
import 'package:flutter_user_github/page/profile_page/profile_setting_page/profile_camera.dart';
import 'package:flutter_user_github/page/profile_page/profile_setting_page/profile_setting_page.dart';
import 'package:flutter_user_github/page/profile_page/profile_setup_page/profile_setup_page.dart';
import 'package:flutter_user_github/page/profile_page/profile_setup_page/shipper_register/shipper_register_page.dart';
import 'package:flutter_user_github/page/profile_page/transferpoint/transfer_point_page.dart';
import 'package:flutter_user_github/page/profile_page/promotion_page/promotion_page.dart';
import 'package:flutter_user_github/page/register_page/register_page.dart';
import 'package:flutter_user_github/page/search_page/camera_page.dart';
import 'package:flutter_user_github/page/search_page/search_page.dart';
import 'package:flutter_user_github/page/store_page/store_detail/store_detail_page.dart';
import 'package:flutter_user_github/page/store_page/store_page.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:get/get.dart';

class AppPages {
  static var list = [
    GetPage(name: AppRoute.LOGIN_PAGE, page: () => LoginPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.REGISTER_PAGE, page: () => RegisterPage(),transition: Transition.fadeIn),
    GetPage(
        name: AppRoute.FORGET_PASSWORD_PAGE, page: () => ForgetPasswordPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.HOME_PAGE, page: () => HomePage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.PROFILE_PAGE, page: () => ProfilePage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.CAMERA_PAGE, page: () => CameraPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.CART_PAGE, page: () => CartPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.STORE_PAGE, page: () => StorePage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.CATEGORY_PAGE, page: () => CategoryPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.ORDER_PAGE, page: () => OrderPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.PRODUCT_ALL_PAGE, page: () => ProductAll(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.PRODUCT_ALL_PAGE, page: () => ProductAll(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.SEARCH_PAGE, page: () => SearchPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.PROFILE_SETTING_PAGE, page: () => ProfileSettingPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.PROFILE_CAMERA_PAGE, page: () => ProfileCamera(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.PROFILE_SETUP_PAGE, page: () => ProfileSetupPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.PROMOTION_PAGE, page: () => PromotionPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.CHART_PAGE, page: () => ChartPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.REGISTER_SHIP_PAGE, page: () => ShipperRegisterPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.ORDER_CART_PAGE, page: () => CartOrder(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.NOTIFICATION_PAGE, page: () => Notification(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.TRANSFER_POINT_PAGE, page: () => TransferPointPage(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.SEARCH_CHAT_PAGE, page: () => SearchChat(),transition: Transition.fadeIn),
    GetPage(name: AppRoute.STORE_CHAT_PAGE, page: () => StoreChat(),transition: Transition.fadeIn),
    GetPage(
        name: AppRoute.ORDER_DETAIL_PAGE,
        page: () {
          String orderCode = Get.parameters['orderCode']!;
          return OrderDetailPage(orderCode: orderCode);
        },
        transition: Transition.fadeIn
        ),
    GetPage(
        name: AppRoute.COMBO_DETAIL,
        page: () {
          var comboId = Get.parameters['comboId'];
          int comboIdInt = int.tryParse(comboId ?? '0') ?? 0;
          return ComboDetail(comboId: comboIdInt);
        },
        transition: Transition.fadeIn),
    GetPage(
        name: AppRoute.STORE_CHAT_DETAIL_PAGE,
        page: () {
          var storeId = Get.parameters['storeId'];
          int storeidInt = int.tryParse(storeId ?? '0') ?? 0;
          return StoreChatDetail(storeid: storeidInt);
        },
        transition: Transition.fadeIn),
    GetPage(
        name: AppRoute.PRODUCT_DETAIL,
        page: () {
          var productId = Get.parameters['productId'];
          int productIdInt = int.tryParse(productId ?? '0') ?? 0;
          return ProductPage(productId: productIdInt);
        },
        transition: Transition.fadeIn
      ),
    GetPage(
        name: AppRoute.CATEGORY_DETAIL_PAGE,
        page: () {
          var categoryid = Get.parameters['categoryid'];
          var categoryname = Get.parameters['categoryname'];
          int categoryidInt = int.tryParse(categoryid ?? '0') ?? 0;
          return CategoryDetailPage(
              categoryid: categoryidInt, categoryname: categoryname!);
        },
        transition: Transition.fadeIn),
     GetPage(
        name: AppRoute.STORE_DETAIL_PAGE,
        page: () {
          var storeid = Get.parameters['storeid'];
          int storeIdInt = int.tryParse(storeid ?? '0') ?? 0;
          return StoreDetailPage(storeId: storeIdInt);
        },transition: Transition.fadeIn),

      GetPage(
        name: AppRoute.USER_CHAT_DETAIL_PAGE,
        page: () {
          var idreceiver = Get.parameters['idreceiver'];
          int idreceiverdInt = int.tryParse(idreceiver ?? '0') ?? 0;
          return HomeChatDetail(idreceiver: idreceiverdInt);
        },transition: Transition.fadeIn),


      GetPage(
        name: AppRoute.ORDER_COMBO_PAGE,
        page: () {
          var comboId = Get.parameters['comboid'];
          var drinkid = Get.parameters['drinkid'];
          int comboIdInt = int.tryParse(comboId ?? '0') ?? 0;
          int drinkIdInt = int.tryParse(drinkid ?? '0') ?? 0;
          return PaymentCombo(idcombo: comboIdInt,iddrink: drinkIdInt,);
        },transition: Transition.fadeIn),
      GetPage(
        name: AppRoute.ORDER_PRODUCT_PAGE,
        page: () {
          var product = Get.parameters['product'];
          var size = Get.parameters['size'];
          var quantity = Get.parameters['quantity'];

          int productInt = int.tryParse(product ?? '0') ?? 0;
          int quantityInt = int.tryParse(quantity ?? '0') ?? 0;
          return ProductOrder(idproduct: productInt,quantity: quantityInt,size: size!,);
        },transition: Transition.fadeIn),
  ];
}
