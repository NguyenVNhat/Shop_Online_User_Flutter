import 'dart:async';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Model/AnnounceModel.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Announcecheckservice extends GetxService {
  Timer? _timer;
  int? previousLength = -1;
  late UserController userController = Get.find<UserController>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<Announcecheckservice> initService() async {
    userController = Get.find<UserController>();
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      await userController.getannounce();
      if (!userController.getloadingannouce) {
       int currentLength = userController.getlistannouce.length;

     
        if (previousLength! < currentLength && previousLength != -1) {
          AnnounceData data = userController.getlistannouce.last;
          await showNotification(data.title!, data.content!);
        }
        previousLength = currentLength;
      }
    });

    return this;
  }

  Future<void> showNotification(String title, String content) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      content,
      platformChannelSpecifics,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
