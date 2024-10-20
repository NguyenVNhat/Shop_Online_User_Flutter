import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/page/profile_page/profile_controll.dart';
import 'package:flutter_user_github/page/profile_page/profile_footer.dart';
import 'package:flutter_user_github/page/profile_page/profile_header.dart';
import 'package:flutter_user_github/page/profile_page/profile_setting.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      body: Stack(
        children: [
         
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/Frame.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
         
          Column(
            children: [
              Obx(() {
                if (!authController.IsLogin.value) {
                  return Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.screenHeight - AppDimention.size60,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.LOGIN_PAGE);
                        },
                        child: Center(
                          child: Text("Vui lòng đăng nhập"),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ProfileHeader(),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          ProfileControll(),
                          ProfileSetting(),
                        ],
                      ),
                    ),
                  );
                }
              }),
              ProfileFooter(),
            ],
          ),
        ],
      ),
    );
  }
}
