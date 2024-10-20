import 'package:flutter_user_github/page/profile_page/profile_footer.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({
    Key? key,
  }) : super(key: key);
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      body: Column(
        children: [
          Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size70,
            decoration: BoxDecoration(color: AppColor.mainColor),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: AppDimention.size70,
                    height: AppDimention.size70,
                    child: Center(
                      child: Icon(
                        Icons.arrow_circle_left,
                        size: AppDimention.size30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: AppDimention.screenWidth - AppDimention.size70,
                  height: AppDimention.size70,
                  padding: EdgeInsets.only(right: AppDimention.size30),
                  child: Center(
                    child: Text(
                      "Cài đặt",
                      style: TextStyle(
                          fontSize: AppDimention.size20, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: AppDimention.size30,
                ),
                Container(
                  width: AppDimention.screenWidth,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        padding: EdgeInsets.only(
                            left: AppDimention.size20,
                            right: AppDimention.size10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: const Color.fromARGB(
                                        255, 194, 193, 193)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Trung tâm hỗ trợ"),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        padding: EdgeInsets.only(
                            left: AppDimention.size20,
                            right: AppDimention.size10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: const Color.fromARGB(
                                        255, 194, 193, 193)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tiêu chuẩn cộng đồng"),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        padding: EdgeInsets.only(
                            left: AppDimention.size20,
                            right: AppDimention.size10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: const Color.fromARGB(
                                        255, 194, 193, 193)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Điều khoản ứng dụng"),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.REGISTER_SHIP_PAGE);
                        },
                        child: Container(
                          width: AppDimention.screenWidth,
                          height: AppDimention.size50,
                          padding: EdgeInsets.only(
                              left: AppDimention.size20,
                              right: AppDimention.size10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: const Color.fromARGB(
                                          255, 194, 193, 193)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Đăng kí giao hàng"),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        padding: EdgeInsets.only(
                            left: AppDimention.size20,
                            right: AppDimention.size10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Giới thiệu"),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          ProfileFooter(),
        ],
      ),
    );
  }
}
