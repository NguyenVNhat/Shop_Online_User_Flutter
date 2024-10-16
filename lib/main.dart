
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/data/controller/Cart_controller.dart';
import 'package:flutter_user_github/data/controller/Category_controller.dart';
import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/data/service/AnnounceCheckService.dart';
import 'package:flutter_user_github/helper/dependencies.dart' as dep;
import 'package:flutter_user_github/route/app_pages.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
   await initNotifications();
  
  bool isLocationEnabled = await checkLocationPermission();
  if (!isLocationEnabled) {
    runApp(LocationErrorApp()); 
  } else {
    runApp(const MyApp());
  }
}
Future<bool> checkLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Kiểm tra dịch vụ vị trí có bật không
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false; 
  }

  // Kiểm tra quyền truy cập vị trí
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Yêu cầu cấp quyền nếu bị từ chối
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Nếu quyền vẫn bị từ chối sau khi yêu cầu
      return false; 
    }
  }

  // Nếu quyền bị từ chối vĩnh viễn
  if (permission == LocationPermission.deniedForever) {
    return false; 
  }

  // Quyền đã được cấp
  return true; 
}


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Obx(() {
      if (authController.IsLogin.value) {
        Get.putAsync(() => Announcecheckservice().initService());
        Get.find<CartController>().getall();
        Get.find<UserController>().getuserprofile();
        Get.find<UserController>().getannounce();
        Get.find<SizeController>().getall();
        Get.find<ComboController>().getall();
        Get.find<ProductController>().getall();
        Get.find<Storecontroller>().getall();
        Get.find<CategoryController>().getall();
      }

      return GetMaterialApp(
        initialRoute: AppRoute.LOGIN_PAGE,
        getPages: AppPages.list,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
      );
    });
  }
}

class LocationErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Please enable location services to proceed.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
