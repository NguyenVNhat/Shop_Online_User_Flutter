import 'package:flutter_user_github/custom/select_setting_custom.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  Color _rowColor = Colors.transparent;
  Color _rowColor1 = Colors.transparent;
  Color _rowColor2 = Colors.transparent;
  Color _rowColor3 = Colors.transparent;
  Color _rowColor4 = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppDimention.size20,
        ),
        Container(
          width: AppDimention.screenWidth,
          margin: EdgeInsets.all(AppDimention.size10),
          padding: EdgeInsets.all(AppDimention.size20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(AppDimention.size10),
            border: Border.all(width: 1,color: Colors.grey.withOpacity(0.1))
            
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.PROFILE_SETTING_PAGE);
                },
                onTapDown: (_) {
                  setState(() {
                    _rowColor = Colors.grey.withOpacity(0.3);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _rowColor = Colors.transparent;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top:AppDimention.size10,bottom: AppDimention.size10),
                  decoration: BoxDecoration(
                    color: _rowColor,
                    borderRadius: BorderRadius.circular(AppDimention.size10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectSettingCustom(
                        icon: Icons.person_2_outlined,
                        title: "Hồ sơ",
                      ),
                      Icon(
                        Icons.arrow_right_rounded,
                        size: AppDimention.size40,
                        color: AppColor.mainColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: AppDimention.size10,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.PROFILE_SETUP_PAGE);
                },
                onTapDown: (_) {
                  setState(() {
                    _rowColor1 = Colors.grey.withOpacity(0.3);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _rowColor1 = Colors.transparent;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top:AppDimention.size10,bottom: AppDimention.size10),
                  
                  decoration: BoxDecoration(
                    color: _rowColor1,
                    borderRadius: BorderRadius.circular(AppDimention.size10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectSettingCustom(
                        icon: Icons.settings_applications_outlined,
                        title: "Cài đặt",
                      ),
                      Icon(
                        Icons.arrow_right_rounded,
                        size: AppDimention.size40,
                        color: AppColor.mainColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: AppDimention.size10,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.NOTIFICATION_PAGE);
                },
                onTapDown: (_) {
                  setState(() {
                    _rowColor3 = Colors.grey.withOpacity(0.3);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _rowColor3 = Colors.transparent;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top:AppDimention.size10,bottom: AppDimention.size10),
                  
                  decoration: BoxDecoration(
                    color: _rowColor3,
                    borderRadius: BorderRadius.circular(AppDimention.size10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectSettingCustom(
                        icon: Icons.circle_notifications_outlined,
                        title: "Thông báo",
                      ),
                      Icon(
                        Icons.arrow_right_rounded,
                        size: AppDimention.size40,
                        color: AppColor.mainColor,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.TRANSFER_POINT_PAGE);
                },
                onTapDown: (_) {
                  setState(() {
                    _rowColor4 = Colors.grey.withOpacity(0.3);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _rowColor4 = Colors.transparent;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top:AppDimention.size10,bottom: AppDimention.size10),
                  
                  decoration: BoxDecoration(
                    color: _rowColor4,
                    borderRadius: BorderRadius.circular(AppDimention.size10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectSettingCustom(
                        icon: Icons.polyline_outlined,
                        title: "Đổi điểm",
                      ),
                      Icon(
                        Icons.arrow_right_rounded,
                        size: AppDimention.size40,
                        color: AppColor.mainColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: AppDimention.size10,
              ),
              GestureDetector(
                onTap: () {
                  Get.find<AuthController>().logout();
                  
                },
                onTapDown: (_) {
                  setState(() {
                    _rowColor2 = Colors.grey.withOpacity(0.3);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _rowColor2 = Colors.transparent;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top:AppDimention.size10,bottom: AppDimention.size10),
                  decoration: BoxDecoration(
                    color: _rowColor2,
                    borderRadius: BorderRadius.circular(AppDimention.size10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectSettingCustom(
                        icon: Icons.login,
                        title: "Đăng xuất",
                      ),
                      Icon(
                        Icons.arrow_right_rounded,
                        size: AppDimention.size40,
                        color: AppColor.mainColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
